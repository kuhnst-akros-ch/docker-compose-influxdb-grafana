import xmltodict
import json
import argparse

def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description="Convert XML file to JSON.")

    # Add file path argument
    parser.add_argument('file_path', type=str, help="The path to the XML file")

    # Parse the arguments
    args = parser.parse_args()

    # Load and parse the XML file
    with open(args.file_path, 'r') as file:
        xml_content = file.read()

    # Convert the XML content to a Python dictionary
    xml_dict = xmltodict.parse(xml_content)

    # Convert the dictionary to a JSON object
    json_data = json.dumps(xml_dict, indent=4)

    # Print the JSON output for inspection
    print(json_data)

if __name__ == "__main__":
    main()

