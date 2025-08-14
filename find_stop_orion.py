import os

SEARCH_DIR = '.'  # Starting directory (current folder)
TARGET_WORDS = ('stop', 'orion')  # Case-insensitive match

match_count = 0

for root, _, files in os.walk(SEARCH_DIR):
    for fname in files:
        if not fname.endswith(('.py', '.json', '.txt', '.cfg', '.yaml', '.yml')):
            continue  # Skip non-code-related files

        fpath = os.path.join(root, fname)
        try:
            with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
                for lineno, line in enumerate(f, 1):
                    lower = line.lower()
                    if all(word in lower for word in TARGET_WORDS):
                        match_count += 1
                        print(f"\n🔹 {fpath} (line {lineno}):")
                        print(f"    {line.strip()}")
        except Exception as e:
            print(f"⚠️  Error reading {fpath}: {e}")

print(f"\n✅ Done. Found {match_count} matching lines with both 'stop' and 'orion'.")
