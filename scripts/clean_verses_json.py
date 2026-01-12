import json
from pathlib import Path
import sys

def clean_verses():
    file_path = Path('data/json/verses.json')
    if not file_path.exists():
        print(f"File not found: {file_path}")
        sys.exit(1)

    print(f"Reading {file_path}...")
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    print(f"Processing {len(data)} records...")
    for item in data:
        fields = item.get('fields', {})

        # Remove mdText and richText
        fields.pop('mdText', None)
        fields.pop('richText', None)

        # Rename verseText to text
        if 'verseText' in fields:
            fields['text'] = fields.pop('verseText')

    print(f"Writing back to {file_path}...")
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

    print("Done.")

if __name__ == "__main__":
    clean_verses()
