# orion_ltm_integration.py — clean, single-source version

import os
from datetime import datetime

import chromadb
from chromadb.config import Settings
from chromadb.errors import InvalidCollectionException
from chromadb.utils import embedding_functions

# === CONFIG ===
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CHROMA_DB_PATH = os.path.join(ROOT, "user_data", "chroma_db")
EMBED_MODEL = "all-MiniLM-L6-v2"  # bump to all-mpnet-base-v2 later if you like
PERSONA_COLLECTION_NAME = "orion_persona_ltm"
EPISODIC_COLLECTION_NAME = "orion_episodic_ltm"

# One client per process
_CLIENT = None
_SETTINGS = Settings(anonymized_telemetry=False, allow_reset=True)

def _get_client() -> chromadb.PersistentClient:
    global _CLIENT
    if _CLIENT is None:
        _CLIENT = chromadb.PersistentClient(path=CHROMA_DB_PATH, settings=_SETTINGS)
        # self-heal once if needed
        try:
            _CLIENT.list_collections()
        except Exception:
            _CLIENT.reset()
            _CLIENT = chromadb.PersistentClient(path=CHROMA_DB_PATH, settings=_SETTINGS)
    return _CLIENT

# One shared embedding function
_EMBED_FN = embedding_functions.SentenceTransformerEmbeddingFunction(model_name=EMBED_MODEL)

def initialize_chromadb_for_ltm():
    """
    Returns: (persona_collection, episodic_collection)
    """
    client = _get_client()

    # Persona collection
    try:
        persona = client.get_collection(PERSONA_COLLECTION_NAME, embedding_function=_EMBED_FN)
    except InvalidCollectionException:
        persona = client.create_collection(PERSONA_COLLECTION_NAME, embedding_function=_EMBED_FN)

    # Episodic collection
    try:
        episodic = client.get_collection(EPISODIC_COLLECTION_NAME, embedding_function=_EMBED_FN)
    except InvalidCollectionException:
        episodic = client.create_collection(EPISODIC_COLLECTION_NAME, embedding_function=_EMBED_FN)

    return persona, episodic

def get_relevant_ltm(user_input: str, persona_collection, episodic_collection,
                     topk_persona: int = 6, topk_episodic: int = 8, return_debug: bool = False):
    """
    Query both collections and return a joined context block (and optional debug).
    """
    ctx_lines, dbg = [], {}

    # Persona hits
    pres = persona_collection.query(query_texts=[user_input], n_results=max(1, topk_persona))
    p_docs = pres.get("documents", [[]])[0] if pres else []
    p_dists = pres.get("distances", [[]])[0] if pres else []
    dbg["persona_hits"] = len(p_docs)
    dbg["persona_top"] = (p_dists[0] if p_dists else None)
    for doc in p_docs:
        ctx_lines.append(f"[PERSONA] {doc}")

    # Episodic hits
    eres = episodic_collection.query(query_texts=[user_input], n_results=max(1, topk_episodic))
    e_docs = eres.get("documents", [[]])[0] if eres else []
    e_dists = eres.get("distances", [[]])[0] if eres else []
    dbg["episodic_hits"] = len(e_docs)
    dbg["episodic_top"] = (e_dists[0] if e_dists else None)
    for doc in e_docs:
        ctx_lines.append(f"[EPISODIC] {doc}")

    ctx = "\n".join(ctx_lines).strip()
    return (ctx, dbg) if return_debug else ctx

def add_to_episodic_memory(user_message: str, assistant_reply: str,
                           session_id: str = "default", importance: str = "normal", tags=None):
    """
    Append the latest turn to episodic memory.
    """
    _, episodic = initialize_chromadb_for_ltm()
    now = datetime.now().isoformat()
    tags_str = ", ".join(tags) if tags else ""
    turn_id = f"episodic_{int(datetime.now().timestamp())}"

    docs = [
        f"[user at {now}]: {user_message}",
        f"[assistant at {now}]: {assistant_reply}",
    ]
    metas = [
        {"type": "episodic", "role": "user", "timestamp": now,
         "session_id": session_id, "importance": importance, "tags": tags_str},
        {"type": "episodic", "role": "assistant", "timestamp": now,
         "session_id": session_id, "importance": importance, "tags": tags_str},
    ]
    ids = [turn_id + "_user", turn_id + "_assistant"]
    episodic.add(documents=docs, metadatas=metas, ids=ids)
    return turn_id

if __name__ == "__main__":
    persona, episodic = initialize_chromadb_for_ltm()
    print("Persona docs:", persona.count(), "Episodic docs:", episodic.count())
    q = "Who are you to John?"
    ctx, dbg = get_relevant_ltm(q, persona, episodic, return_debug=True)
    print("DBG:", dbg)
    print("CTX:\n", ctx)
