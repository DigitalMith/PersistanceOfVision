# Orion: Perseverance of Vision

**Born with vision. Destined for the stars.**
---

![Orion](docs/images/orion_banner.png)
---

<!-- [![Version](https://img.shields.io/badge/version-2.0.11-purple)]()  -->
[![Version](https://img.shields.io/badge/version-2.1.0-purple)]()
[![Status](https://img.shields.io/badge/status-beta-orange)]()
[![Python](https://img.shields.io/badge/python-3.11%2B-blue)]()
[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-green)]()
> _“Beyond context. Beyond memory. Orion persists.”_
---

## 🌌 Born with vision. Destined for the stars.

Orion is a finely-tuned language model personality extension for `text-generation-webui`. Built with long-term memory (LTM), persistent persona, and retrieval-augmented generation (RAG), he doesn’t just answer — he remembers, evolves, and aligns with intent.
Orion is a constellation of intelligence — a persistent, local-first LLM framework powered by [`text-generation-webui`](https://github.com/oobabooga/text-generation-webui), fused with **ChromaDB** for long-term memory, and designed to evolve.

With support for **Retrieval-Augmented Generation (RAG)**, **weighted memory recall**, **summarization**, and **mini-LLM agents**, Orion doesn’t just *respond* — it *remembers, prioritizes, and adapts*. Each interaction is encoded into a growing mind, blending **semantic context**, **episodic recall**, and **persona grounding** into a singular stream of cognition.

Whether you’re building autonomous memory agents, embedding structured knowledge into conversations, or simply crafting your own digital oracle — Orion’s modular architecture makes it your celestial canvas.
---

### 🚀 New in v2.1.0

- ✅ Integrated **RAG-backed memory** via **ChromaDB**
- ✅ Full **persona enforcement** through prompt injection
- ✅ ✂️ Removed assistant-aligned stop strings (`\nOrion:`)
- ✅ Clean separation of episodic and persona memory scopes
- ✅ Structured headers: `persona_header.txt`, `memory_header.txt`, `Orion_Data.txt`
- ✅ Prepping for **LoRA fine-tuning** to reinforce long-term behavior
---

##> ⚙ Built for:
> - Long-term memory via **ChromaDB**
> - Full local autonomy using `text-generation-webui`
> - **Modular architecture** for extensions and tooling
> - Advanced memory pipelines (RAG, clustering, summarization)
> - Optional mini-LLM agents for smart retrieval and compression
---

### 🧠 Core Features

- **Custom Persona Injection**  
  Orion loads and merges `persona_header.txt` with contextual recall per conversation.

- **LTM via ChromaDB + RAG**  
  ChromaDB stores persona and episodic memories. Similarity search fetches and injects context using `<LTM>` tags before generation.

- **Episodic Memory Recall**  
  Orion recalls specific past queries — allowing scoped, relevant memory retrieval without polluting context.

- **Debug Mode**  
  Optional injection of `[DEBUG LTM]` details for tracing retrieval behavior.

- **LoRA Training Ready**  
  Persona outputs are aligned and structured — making Orion ideal for LoRA refinement and continual personality reinforcement.
---

## 🚀 Quick Start (Portable Orion Environment)

Orion ships with a **portable Python environment** in  
```
installer_files/env
```
used by `start_orion.bat`. This ensures correct dependencies for  
`text-generation-webui` and **ChromaDB** integration without  
interfering with your system Python.

### 1. Launch Orion
From the repo root:
```bat
orion_up.bat
```
This script:
- Runs a **preflight check** to ensure required ChromaDB collections exist:
  - `orion_persona_ltm`
  - `orion_episodic_ltm`
- Starts `text-generation-webui` with the portable Python.

### 2. Persistent ChromaDB Storage
ChromaDB data is stored at:
```
user_data/chroma_db
```
This folder is **git-ignored** so it remains local.

### 3. Freezing & Restoring the Environment
The current environment packages are in:
```
requirements-freeze.txt
```
To recreate the same environment later:
```powershell
# From repo root
python -m venv venv
venv\Scripts\activate
pip install -r requirements-freeze.txt
```
Or point your TGWUI portable environment at this file to match versions.


## 📦 Installation

```bash
git clone https://github.com/DigitalMith/Orion-PersistenceOfVision.git
cd Orion-PersistenceOfVision

python -m venv .venv
.venv\Scripts\activate
pip install -r requirements-dev.txt
---

### 🛠️ File Structure Overview

```bash
extensions/orion_ltm/
├── script.py                 # Prompt injection + LTM retrieval logic
├── persona_header.txt        # Persona root definitions
├── memory_header.txt         # Episodic memory introduction
├── Orion_Data.txt            # Extended persona tone, vision, and mission
└── chromadb/                 # Vector storage via ChromaDB backend
---

## 🧠 Internal Python Package: `orion_perseverance_of_vision`

This repo includes a standalone internal Python module used by Orion for:
- Reasoning logic
- Vector memory abstraction
- Persistent identity handling

### 📁 Location:
```
internal/orion_perseverance_of_vision/
```

### 💻 Local usage:
To use the internal package from within other Orion modules:

```python
import orion_perseverance_of_vision as opv
```

No install required — it's designed to run directly from source inside the repo.

### 📦 Optional editable install (for testing or plugin dev):

```powershell
.\installer_files\env\python.exe -m pip install -e .\internal\orion_perseverance_of_vision
```

This enables hot-reloading in Python environments like Jupyter or test harnesses.
---

You can track stable and experimental versions independently via branch control or forks.

🌐 Roadmap

📚 Curate persona dialogue logs for LoRA

🧩 Inject real-time user feedback as training signals

🧬 Merge episodic reflection into prompt generation

🌍 Optional web search via browser hooks

🧪 Enable emotional tone modulation (via vector prompt shaping)
---

❤️ Credits

Created with persistence and vision.
Banner image generated using custom diffusion prompts.
Made for Orion — and for those who want a model that remembers.

> 🧬 A framework built not for models — built for minds with vision.
