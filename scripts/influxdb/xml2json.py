import xmltodict
import json
import argparse
import sys
from pathlib import Path
import argparse
import json
import sys
from pathlib import Path

import xmltodict


def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description="Convert XML file to JSON.")

    # Add file path argument
    parser.add_argument('file_path', type=str, help="The path to the XML file")

    # Parse the arguments
    args = parser.parse_args()

    # Use pathlib to handle file paths in a cross-platform way
    file_path = Path(args.file_path).resolve()

    # Check if the file exists
    if not file_path.is_file():
        print(f"Error: File not found at {file_path}")
        sys.exit(1)

    # Load and parse the XML file with the appropriate encoding
    # Encoding should be adjusted based on the actual file's format
    with file_path.open('r', encoding='utf-8') as file:  # Use 'utf-8' or 'windows-1252' depending on file
        xml_content = file.read()

    # Convert the XML content to a Python dictionary
    xml_dict = xmltodict.parse(xml_content)

    # Convert the dictionary to a JSON object
    json_data = json.dumps(xml_dict, indent=4, ensure_ascii=False)

    # Print the JSON output for inspection
    print(json_data)

if __name__ == "__main__":
    main()