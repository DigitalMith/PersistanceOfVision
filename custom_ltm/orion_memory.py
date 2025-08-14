# custom_ltm/orion_memory.py
import os
from typing import Iterable, List, Dict, Any
from pathlib import Path
import chromadb
from chromadb.config import Settings
from chromadb.utils import embedding_functions

ROOT = Path(__file__).resolve().parents[1]
CHROMA_DB_PATH = os.getenv("CHROMA_DB_PATH", str(ROOT / "user_data" / "chroma_db"))

COLL_EPISODIC_RAW  = os.getenv("ORION_EPISODIC_COLLECTION",      "orion_episodic_ltm")
COLL_EPISODIC_SENT = os.getenv("ORION_EPISODIC_SENT_COLLECTION", "orion_episodic_sent_ltm")

EMBED = embedding_functions.SentenceTransformerEmbeddingFunction(
    model_name="all-MiniLM-L6-v2"
)

def _client():
    # Persistent on-disk DB; loads automatically if it exists. :contentReference[oaicite:0]{index=0}
    return chromadb.PersistentClient(path=CHROMA_DB_PATH, settings=Settings(anonymized_telemetry=False))

def _get(name: str):
    c = _client()
    # If created with an embedding function, you must get it with the same function later. :contentReference[oaicite:1]{index=1}
    try:
        return c.get_collection(name=name, embedding_function=EMBED)
    except Exception:
        return c.get_or_create_collection(name=name, embedding_function=EMBED)  # convenience API. :contentReference[oaicite:2]{index=2}

def _flatten_query(res: Dict[str, Any]) -> List[Dict[str, Any]]:
    out: List[Dict[str, Any]] = []
    ids = res.get("ids") or []
    docs = res.get("documents")
    metas = res.get("metadatas")
    dists = res.get("distances")
    for i in range(len(ids)):
        for j, _id in enumerate(ids[i]):
            out.append({
                "id": _id,
                "document": (docs[i][j] if docs else None),
                "metadata": (metas[i][j] if metas else None),
                "distance": (dists[i][j] if dists else None),
                "query_index": i,
                "rank": j,
            })
    return out

def prefer_sentenced(
    query_texts: Iterable[str],
    n_results: int = 8,
    importance_threshold: float = 0.5,
    include: Iterable[str] = ("documents", "metadatas"),  # choose payload fields. :contentReference[oaicite:3]{index=3}
    fallback_to_raw: bool = True,
) -> List[Dict[str, Any]]:
    """Query sentenced memories first; optionally top-up from raw episodic."""
    sent = _get(COLL_EPISODIC_SENT)
    raw  = _get(COLL_EPISODIC_RAW)

    # 1) sentenced first + metadata filter (importance >= threshold). :contentReference[oaicite:4]{index=4}
    sent_res = sent.query(
        query_texts=list(query_texts),
        n_results=n_results,
        where={"importance": {"$gte": importance_threshold}},     # metadata where filter. :contentReference[oaicite:5]{index=5}
        include=list(include),
    )
    hits = _flatten_query(sent_res)
    seen_ids = {h["id"] for h in hits}
    need = max(0, n_results - len(hits))

    # 2) optional fallback to raw episodic if not enough sentenced hits
    if fallback_to_raw and need > 0:
        raw_res = raw.query(
            query_texts=list(query_texts),
            n_results=n_results * 2,  # over-fetch, then trim
            include=list(include),
        )  # you can also add where/where_document filters. :contentReference[oaicite:6]{index=6}
        pool = [r for r in _flatten_query(raw_res) if r["id"] not in seen_ids]
        hits.extend(pool[:need])

    # Optional: sort by distance when available
    hits.sort(key=lambda x: (x["query_index"], x["distance"] if x["distance"] is not None else 9e9))
    return hits
