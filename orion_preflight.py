import os
import chromadb

# Path to persistent Chroma DB
CHROMA_PATH = r"C:\Orion\text-generation-webui\user_data\chroma_db"

# Required collections
REQUIRED_COLLECTIONS = ["orion_persona_ltm", "orion_episodic_ltm"]

def ensure_collections():
    os.makedirs(CHROMA_PATH, exist_ok=True)
    client = chromadb.PersistentClient(path=CHROMA_PATH)
    for name in REQUIRED_COLLECTIONS:
        client.get_or_create_collection(name=name)
        print(f"✔ Collection '{name}' ready.")
    print(f"All collections ready at: {CHROMA_PATH}")

if __name__ == "__main__":
    ensure_collections()
