import os
from chromadb import PersistentClient
from chromadb.utils import embedding_functions

# Disable Chroma telemetry
os.environ["CHROMA_TELEMETRY"] = "False"

# Path to persistent DB
PERSIST_DIRECTORY = "./orion_ltm_db"

# Create embedding function
EMBED_MODEL = "all-MiniLM-L6-v2"
embedding_fn = embedding_functions.SentenceTransformerEmbeddingFunction(model_name=EMBED_MODEL)

# Use local persistent ChromaDB
client = PersistentClient(path=PERSIST_DIRECTORY)

# Create collections if they don't exist
persona = client.get_or_create_collection("orion_persona_ltm", embedding_function=embedding_fn)
episodic = client.get_or_create_collection("orion_episodic_ltm", embedding_function=embedding_fn)

print("✅ Created ChromaDB collections:")
print(f" - {persona.name}")
print(f" - {episodic.name}")
