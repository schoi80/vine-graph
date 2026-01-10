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
        place_id = fields.get('placeID')
        kjv_name = fields.get('kjvName')
        
        # Only add if we have both or at least one? 
        # The user asked for a CSV of placeID, kjvName.
        rows.append({
            'placeID': place_id,
            'kjvName': kjv_name
        })

    # Write to CSV
    with open(output_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['placeID', 'kjvName'])
        writer.writeheader()
        writer.writerows(rows)

if __name__ == "__main__":
    input_file = "/Volumes/External/github/vine-graph/data/json/places.json"
    output_file = "/Volumes/External/github/vine-graph/data/csv/places.csv"
    
    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    convert_json_to_csv(input_file, output_file)
    print(f"Created CSV at: {output_file}")
