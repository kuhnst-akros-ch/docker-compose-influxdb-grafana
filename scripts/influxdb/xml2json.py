import xmltodict
import json

# Load and parse the XML file
with open('data.xml', 'r') as file:
    xml_content = file.read()

# Convert the XML content to a Python dictionary
xml_dict = xmltodict.parse(xml_content)

# Convert the dictionary to a JSON object
json_data = json.dumps(xml_dict, indent=4)

# Print the JSON output for inspection
print(json_data)
