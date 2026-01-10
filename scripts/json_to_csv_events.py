import json
import csv
import os

def convert_json_to_csv(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Prepare data for CSV
    rows = []
    for item in data:
        fields = item.get('fields', {})
        id = item.get('id')
        title = fields.get('title')

        rows.append({
            'id': id,
            'title': title
        })

    # Write to CSV
    with open(output_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['id', 'title'])
        writer.writeheader()
        writer.writerows(rows)

if __name__ == "__main__":
    input_file = "/Volumes/External/github/vine-graph/data/json/events.json"
    output_file = "/Volumes/External/github/vine-graph/data/csv/events.csv"

    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    convert_json_to_csv(input_file, output_file)
    print(f"Created CSV at: {output_file}")
