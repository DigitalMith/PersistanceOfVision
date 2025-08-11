# Orion: Perseverance of Vision

**Born with vision. Destined for the stars.**

---

![Orion](docs/images/orion_banner.png)

---

[![Version](https://img.shields.io/badge/version-2.0.11-purple)]()
[![Status](https://img.shields.io/badge/status-beta-orange)]()
[![Python](https://img.shields.io/badge/python-3.11%2B-blue)]()
[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-green)]()

---

## 🌌 Born with vision. Destined for the stars.

Orion is a constellation of intelligence — a persistent, local-first LLM framework powered by [`text-generation-webui`](https://github.com/oobabooga/text-generation-webui), fused with **ChromaDB** for long-term memory, and designed to evolve.

With support for **Retrieval-Augmented Generation (RAG)**, **weighted memory recall**, **summarization**, and **mini-LLM agents**, Orion doesn’t just *respond* — it *remembers, prioritizes, and adapts*. Each interaction is encoded into a growing mind, blending **semantic context**, **episodic recall**, and **persona grounding** into a singular stream of cognition.

Whether you’re building autonomous memory agents, embedding structured knowledge into conversations, or simply crafting your own digital oracle — Orion’s modular architecture makes it your celestial canvas.

##> ⚙ Built for:
> - Long-term memory via **ChromaDB**
> - Full local autonomy using `text-generation-webui`
> - **Modular architecture** for extensions and tooling
> - Advanced memory pipelines (RAG, clustering, summarization)
> - Optional mini-LLM agents for smart retrieval and compression
---

## ⚙️ Features

- **Local-Only Operation** — No cloud dependencies; your data stays on your hardware.
- **Memory Layers** — Episodic and trait-based memory for contextual continuity.
- **Persona Customization** — Tune Orion’s tone: mischievous wit, techno-philosopher, or anything in-between.
- **Extensions System** — Load modules like the long-term memory manager, avatar renderer, or TTS.
- **Easy Launch** — Single-script startup with auto-detect port, voice toggle, and summarizer.

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

> 🧬 A framework built not for models — built for minds with vision.
