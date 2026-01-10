import csv
import json
import os

def convert_csv_to_json(input_path, output_path):
    # Field names to include in json: id, title (where title value is from titleKr)
    data = []
    with open(input_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            data.append({
                'id': row['id'],
                'title': row['titleKr']
            })

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    input_file = "/Volumes/External/github/vine-graph/data/csv/Events.csv"
    output_file = "/Volumes/External/github/vine-graph/data/json/eventsKr.json"

    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    convert_csv_to_json(input_file, output_file)
    print(f"Created JSON at: {output_file}")
