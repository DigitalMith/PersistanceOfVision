# extensions/orion_ltm/script.py
import os, sys, re
from modules.logging_colors import logger

# Make sure we can import your integration module
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
CUSTOM_LTM = os.path.join(ROOT, "custom_ltm")
for p in (ROOT, CUSTOM_LTM):
    if p not in sys.path:
        sys.path.insert(0, p)

try:
    from custom_ltm.orion_ltm_integration import (
        initialize_chromadb_for_ltm,
        get_relevant_ltm,
    )
except Exception as e:
    logger.error(f"[orion_ltm] import failed: {e}")
    raise

persona_coll = episodic_coll = None  # kept only for backward-compat logging, not used for calls
LTM_READY = False
DEBUG = os.environ.get("ORION_LTM_DEBUG", "0") == "1"
TOPK_PERSONA = int(os.environ.get("ORION_LTM_TOPK_PERSONA", "6"))
TOPK_EPISODIC = int(os.environ.get("ORION_LTM_TOPK_EPISODIC", "8"))

def setup():
    """Called by TGWUI at startup for each extension."""
    global persona_coll, episodic_coll, LTM_READY
    # Warm Chroma + get counts for logging; collections are not used elsewhere
    persona_coll, episodic_coll, _ = initialize_chromadb_for_ltm()
    try:
        pc = persona_coll.count()
        ec = episodic_coll.count()
    except Exception:
        pc = ec = -1
    logger.info(f"[orion_ltm] setup() → Persona={pc} Episodic={ec}")
    LTM_READY = True

def _extract_last_user_message(text: str) -> str:
    m = list(re.finditer(r"(?:^|\n)[<\[]?user[>\]]?:?\s*(.*)$", text, flags=re.IGNORECASE))
    if m:
        return m[-1].group(1).strip()
    return text[-2000:].strip()

def input_modifier(prompt: str, state):
    """Called right before generation; return modified prompt."""
    
    # --- REMOVE '\nOrion:' FROM STOP STRINGS IF PRESENT ---
    if isinstance(state, dict):
        stops = state.get("stop_str", [])
        if "\nOrion:" in stops:
            stops.remove("\nOrion:")
    
    if not LTM_READY:
        return prompt

    user_text = (state.get("user_input") if isinstance(state, dict) else None) or _extract_last_user_message(prompt)
    if not user_text:
        return prompt

    # get_relevant_ltm manages its own Chroma client/collections internally
    ctx, dbg = get_relevant_ltm(
        user_input=user_text,
        topk_persona=TOPK_PERSONA,
        topk_episodic=TOPK_EPISODIC,
        return_debug=True,
    )
    if not ctx:
        return prompt

    ltm_block = f"<LTM query='{user_text.strip()}'>\n" + ctx.strip() + "\n</LTM>\n"
    new_prompt = ltm_block + prompt

    if DEBUG and dbg:
        new_prompt += (
            "\n[DEBUG LTM] "
            f"persona={dbg.get('persona_hits', 0)} episodic={dbg.get('episodic_hits', 0)} "
            f"p_top={dbg.get('persona_top', None)} e_top={dbg.get('episodic_top', None)}\n"
        )
    return new_prompt


def output_modifier(text: str, state):
    """Optional: tag output while testing so you can *see* it’s on."""
    if DEBUG:
        return (text or "") + "\n\n[orion_ltm active]"
    return text
