import sys
import json
import xmltodict

def main():
    # Read the XML file
    with open(sys.argv[1], 'r', encoding='utf-8') as file:
        xml_content = file.read()

    # Convert XML to dictionary
    data_dict = xmltodict.parse(xml_content)

    # Convert dictionary to JSON
    json_data = json.dumps(data_dict, ensure_ascii=False, indent=4)

    # Print JSON output (make sure the output uses utf-8 encoding)
    sys.stdout.reconfigure(encoding='utf-8')
    print(json_data)

if __name__ == '__main__':
    main()
