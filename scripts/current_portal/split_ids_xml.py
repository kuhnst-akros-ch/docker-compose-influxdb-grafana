import os
import xml.etree.ElementTree as ET
import argparse
import uuid

def extract_publications(xml_file, target_folder):
	try:
		# Try loading the XML file
		tree = ET.parse(xml_file)
		root = tree.getroot()

	except FileNotFoundError:
		print(f"Error: The file '{xml_file}' was not found.")
		return
	except ET.ParseError as e:
		print(f"Error: Failed to parse the XML file. {e}")
		return

	# Define the namespace for elements that have it
	ns = {'bulk': 'https://shab.ch/bulk-export'}

	# Ensure the target folder exists
	if not os.path.exists(target_folder):
		os.makedirs(target_folder)

	# Use an XPath without the namespace for <publication> elements
	publications = root.findall('.//publication')

	if not publications:
		print(f'No <publication> elements found in {xml_file}')
		return

	# Extract each publication and save it as a separate file
	for i, publication in enumerate(publications):
		# Create a new XML tree for each publication
		publication_tree = ET.ElementTree(publication)

		# Generate a file name for the output
		uuid_str = str(uuid.uuid4())
		file_name = os.path.join(target_folder, f'{uuid_str}.xml')

		# Write the publication element to a new file
		publication_tree.write(file_name, encoding='utf-8', xml_declaration=True)

		print(f'Extracted publication to {file_name}')

if __name__ == "__main__":
	# Set up argument parsing
	parser = argparse.ArgumentParser(description="Extract <publication> elements from XML file into separate files.")
	parser.add_argument('xml_file', help="Path to the input XML file")
	parser.add_argument('target_folder', help="Path to the folder where extracted publications will be saved")

	# Parse the arguments
	args = parser.parse_args()

	# Call the extraction function
	extract_publications(args.xml_file, args.target_folder)
