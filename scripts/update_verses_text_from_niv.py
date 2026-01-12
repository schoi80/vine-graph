import json
from pathlib import Path
import sys

def update_texts():
    verses_path = Path('data/json/verses.json')
    niv_path = Path('data/json/versesNiv.json')

    if not verses_path.exists():
        print(f"Verses file not found: {verses_path}")
        sys.exit(1)
    if not niv_path.exists():
        print(f"NIV file not found: {niv_path}")
        sys.exit(1)

    print(f"Loading NIV data from {niv_path}...")
    with open(niv_path, 'r', encoding='utf-8') as f:
        niv_data = json.load(f)
    # Build a mapping from osisRef to text
    niv_map = {item.get('osisRef'): item.get('text') for item in niv_data}

    print(f"Loading verses data from {verses_path}...")
    with open(verses_path, 'r', encoding='utf-8') as f:
        verses_data = json.load(f)

    updated = 0
    for entry in verses_data:
        fields = entry.get('fields', {})
        osis = fields.get('osisRef')
        if osis and osis in niv_map:
            # Update the text field (previously renamed from verseText)
            fields['text'] = niv_map[osis]
            updated += 1
        else:
            # No matching NIV entry; leave as is
            pass

    print(f"Updated {updated} verses with NIV text.")
    print(f"Writing back to {verses_path}...")
    with open(verses_path, 'w', encoding='utf-8') as f:
        json.dump(verses_data, f, indent=4, ensure_ascii=False)
    print("Done.")

if __name__ == '__main__':
    update_texts()
