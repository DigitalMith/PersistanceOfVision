# seed_episodic_memory.py
# Ingest chat logs (and optional long_term_memory.json) into ChromaDB episodic LTM.

import os
import json
import hashlib
from pathlib import Path
from datetime import datetime

import chromadb
from chromadb.config import Settings
from chromadb.utils import embedding_functions

# -------- Paths & config (override via env if needed) --------
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = (SCRIPT_DIR / "..").resolve()

EPISODIC_COLLECTION_NAME = os.getenv("ORION_EPISODIC_COLLECTION", "orion_episodic_ltm")
CHROMA_DB_PATH = os.getenv("CHROMA_DB_PATH", str(PROJECT_ROOT / "user_data" / "chroma_db"))
CHAT_DIR = Path(os.getenv("ORION_CHAT_DIR", r"C:\Orion\memory\chat"))
LONG_TERM_MEMORY_FILE = Path(os.getenv("ORION_LONG_TERM_MEMORY_FILE", r"C:\Orion\memory\long_term_memory.json"))

# One embedding fn (same model as persona seeding)
EMBED_FN = embedding_functions.SentenceTransformerEmbeddingFunction(
    model_name="all-MiniLM-L6-v2"
)

def make_id(session_id, role, content, when, counter):
    h = hashlib.sha1(f"{role}|{content}|{when}".encode("utf-8")).hexdigest()[:12]
    return f"episodic_{session_id}_{h}_{counter}"

def get_client() -> chromadb.PersistentClient:
    """Create a persistent client so data survives reinstalls."""
    return chromadb.PersistentClient(path=CHROMA_DB_PATH, settings=Settings(anonymized_telemetry=False))

def load_all_episodic():
    """Build episodic docs from chat logs + optional long_term_memory.json."""
    docs, ids, metas = [], [], []
    counter = 0

    def push(role, content, when, session_id, importance="normal", tags=None):
        nonlocal counter
        content = (content or "").strip()
        if not content:
            return
        when = str(when or "")
        role = (role or "unknown").lower()
        docs.append(f"[{role} at {when}]: {content}")
        ids.append(make_id(session_id, role, content, when, counter))
        metas.append({
            "type": "episodic",
            "role": role,
            "timestamp": when,
            "session_id": session_id,
            "importance": str(importance),
            "tags": ", ".join(tags or []),
        })
        counter += 1

    # 1) Chat transcripts
    if CHAT_DIR.is_dir():
        for f in sorted(CHAT_DIR.glob("*.json")):
            try:
                raw = f.read_text(encoding="utf-8")
                data = json.loads(raw)
            except Exception as e:
                print(f"Skipping {f.name}: {e}")
                continue

            session_id = f.stem
            turns = data.get("messages") if isinstance(data, dict) else data
            if not isinstance(turns, list):
                continue

            fallback_time = session_id
            for t in turns:
                role = (t.get("role") or t.get("speaker") or "unknown")
                content = (t.get("content") or t.get("text") or "")
                when = t.get("timestamp") or t.get("time") or fallback_time
                push(role, content, when, session_id, t.get("importance", "normal"), t.get("tags"))

    # 2) Optional long_term_memory.json
    if LONG_TERM_MEMORY_FILE.is_file():
        try:
            raw = LONG_TERM_MEMORY_FILE.read_text(encoding="utf-8")
            data = json.loads(raw)
            turns = data if isinstance(data, list) else data.get("messages", [])
            if isinstance(turns, list):
                for t in turns:
                    role = (t.get("role") or t.get("speaker") or "unknown")
                    content = (t.get("content") or t.get("text") or "")
                    when = t.get("timestamp") or t.get("time") or "n/a"
                    push(role, content, when, "long_term_memory", t.get("importance", "normal"), t.get("tags"))
        except Exception as e:
            print(f"Warning reading long_term_memory.json: {e}")

    return docs, ids, metas

def main():
    print(f"Chroma path: {CHROMA_DB_PATH}")
    print(f"Chat dir:    {CHAT_DIR}")
    print(f"LTM file:    {LONG_TERM_MEMORY_FILE}")

    client = get_client()

    # Assemble episodic docs
    docs, ids, metas = load_all_episodic()
    if not docs:
        print("No episodic memories found (nothing to add).")
        return

    # Delete and recreate collection fresh
    try:
        client.delete_collection(name=EPISODIC_COLLECTION_NAME)
    except Exception:
        pass

    episodic_collection = client.create_collection(
        name=EPISODIC_COLLECTION_NAME,
        embedding_function=EMBED_FN,
    )

    # Add to ChromaDB
    episodic_collection.add(documents=docs, metadatas=metas, ids=ids)
    print(f"Added {len(docs)} episodic memories.")
    try:
        print(f"Collection count now: {episodic_collection.count()}")
    except Exception:
        pass

if __name__ == "__main__":
    main()
