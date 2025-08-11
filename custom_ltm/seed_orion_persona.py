import os
import chromadb
from chromadb.utils import embedding_functions
from chromadb.config import Settings

# --- Config ---
SCRIPT_DIR = os.path.dirname(__file__)
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))

CHROMA_DB_PATH = os.getenv("CHROMA_DB_PATH", os.path.join(PROJECT_ROOT, "user_data", "chroma_db"))
PERSONA_COLLECTION_NAME = os.getenv("ORION_PERSONA_COLLECTION", "orion_persona_ltm")
ORION_DATA_FILE = os.getenv("ORION_PERSONA_FILE", r"C:\Orion\memory\Orion_Data.txt")

EMBED_FN = embedding_functions.SentenceTransformerEmbeddingFunction(
    model_name="all-MiniLM-L6-v2"
)

# --- Load persona data ---
def load_orion_persona(file_path):
    persona_statements = []
    if not os.path.exists(file_path):
        print(f"ERROR: Persona file not found at {file_path}")
        return []

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    sections = {
        "PERSONA_HEADER_CORE": content.split("Obtained from persona_header.txt:")[1].strip()
            if "Obtained from persona_header.txt:" in content else "",
        "IDENTITY": content.split("[IDENTITY]")[1].split("[BEHAVIORAL CORE]")[0].strip()
            if "[IDENTITY]" in content else "",
        "BEHAVIORAL CORE": content.split("[BEHAVIORAL CORE]")[1].split("[RELATIONSHIP WITH JOHN]")[0].strip()
            if "[BEHAVIORAL CORE]" in content else "",
        "RELATIONSHIP WITH JOHN": content.split("[RELATIONSHIP WITH JOHN]")[1].split("[TONE AND VOICE]")[0].strip()
            if "[RELATIONSHIP WITH JOHN]" in content else "",
        "TONE AND VOICE": content.split("[TONE AND VOICE]")[1].split("[META-NOTES]")[0].strip()
            if "[TONE AND VOICE]" in content else "",
        "MEMORY_HEADER_CORE": content.split("Obtained from memory_header.txt:")[1].split("Obtained from persona_header.txt:")[0].strip()
            if "Obtained from memory_header.txt:" in content else "",
        "ORION_JSON_CORE": content.split("Obtained from orion_perseverance_of_vision.json:")[1].split("Obtained from memory_header.txt:")[0].strip()
            if "Obtained from orion_perseverance_of_vision.json:" in content else "",
    }

    for text in sections.values():
        if not text:
            continue
        for line in text.splitlines():
            line = line.strip()
            if line.startswith("-"):
                line = line[1:].strip()
            if line and not line.startswith('["John",') and not line.startswith('["Orion",') \
               and not line.startswith('"example_dialogue"'):
                persona_statements.append(line)

    # Remove duplicates & filter short lines
    persona_statements = list(dict.fromkeys([s for s in persona_statements if len(s) > 10]))
    return persona_statements

# --- Main ---
def main():
    print(f"Chroma path: {CHROMA_DB_PATH}")
    print(f"Persona file: {ORION_DATA_FILE}")

    client = chromadb.PersistentClient(
        path=CHROMA_DB_PATH,
        settings=Settings(anonymized_telemetry=False)
    )

    # Delete and recreate collection
    try:
        client.delete_collection(name=PERSONA_COLLECTION_NAME)
    except Exception:
        pass

    persona_collection = client.create_collection(
        name=PERSONA_COLLECTION_NAME,
        embedding_function=EMBED_FN,
    )

    # Load persona data
    persona_docs = load_orion_persona(ORION_DATA_FILE)
    if not persona_docs:
        print(f"Warning: No persona statements loaded from {ORION_DATA_FILE}.")
        return

    doc_ids = [f"persona_{i}" for i in range(len(persona_docs))]
    persona_collection.add(
        documents=persona_docs,
        metadatas=[{"type": "persona", "source": "Orion_Data.txt"} for _ in persona_docs],
        ids=doc_ids
    )

    print(f"Added {len(persona_docs)} persona statements.")
    print(f"Collection count now: {persona_collection.count()}")

if __name__ == "__main__":
    main()
