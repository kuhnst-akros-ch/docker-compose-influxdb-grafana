import json
import argparse
import sys
from collections.abc import MutableMapping

def flatten_json(nested_json):
	"""
	Flattens a nested JSON object, keeping only the immediate key (ignoring the path).
	If an array (list) is encountered, only the first item is processed.
	"""
	items = {}

	for key, value in nested_json.items():
		if isinstance(value, MutableMapping):
			# Recursively flatten dictionaries
			flat_dict = flatten_json(value)
			for inner_key, inner_value in flat_dict.items():
				# Skip duplicates
				if inner_key not in items:
					items[inner_key] = inner_value
		elif isinstance(value, list) and value:
			# Process only the first item in the list
			if isinstance(value[0], MutableMapping):
				flat_dict = flatten_json(value[0])
				for inner_key, inner_value in flat_dict.items():
					if inner_key not in items:
						items[inner_key] = inner_value
			else:
				items[key] = value[0]
		else:
			# Add key directly, skip if duplicate
			if key not in items:
				items[key] = value

	return items

def sanitize_value(value):
	"""
	Wraps string values in double quotes.
	Booleans and numbers are not quoted.
	Escapes special characters for InfluxDB line protocol.
	"""
	if isinstance(value, str):
		# Escape special characters for InfluxDB line protocol
		value = (value.replace(',', '\,')
				 .replace(' ', '\ ')
				 .replace('\r', '\ ')
				 .replace('\n', '\ '))
		return f'"{value}"'
	elif isinstance(value, bool):
		return 'true' if value else 'false'
	else:
		return str(value)

def classify_keys(flattened_json):
	"""
	Classifies all key-value pairs into tags, fields.
	No special treatment for the first key-value pair.
	"""
	tags = {}
	fields = {}

	# Iterate through all key-value pairs and classify them
	for key, value in flattened_json.items():
		# Classify based on value type: assume strings and booleans are tags, numbers are fields
		if isinstance(value, (str, bool)):
			tags[key] = value
		elif isinstance(value, (int, float)):
			fields[key] = value
		else:
			# Handle other types by converting them to strings
			fields[key] = sanitize_value(str(value))

	return tags, fields

def json_to_line_protocol(data):
	"""
	Convert JSON data to a format with key=value pairs, with values wrapped in double quotes where necessary.
	The output consists only of key-value pairs separated by commas, with no measurement.
	"""
	flattened_data = flatten_json(data)

	# Sanitize and construct key-value pairs
	kv_str = ','.join([f"{key}={sanitize_value(value)}" for key, value in flattened_data.items()])

	return kv_str

def read_json_from_file(file_path):
	"""Reads JSON data from a file."""
	with open(file_path, 'r') as file:
		return json.load(file)

def read_json_from_pipe():
	"""Reads JSON data from standard input (pipe)."""
	return json.load(sys.stdin)

def main():
	# Create argument parser
	parser = argparse.ArgumentParser(description="Convert JSON to InfluxDB line protocol.")

	# Add file path argument (optional, since input can also come from pipe)
	parser.add_argument('file_path', type=str, nargs='?', help="The path to the JSON file (optional if reading from pipe)")

	# Parse arguments
	args = parser.parse_args()

	# Determine if input is from file or pipe
	if args.file_path:
		# Read JSON from file
		json_data = read_json_from_file(args.file_path)
	elif not sys.stdin.isatty():
		# Read JSON from pipe (if available)
		json_data = read_json_from_pipe()
	else:
		print("Error: No input provided. Provide a file or use pipe input.")
		sys.exit(1)

	# Convert JSON to line protocol, using 'data' as a generic measurement
	line_protocol = json_to_line_protocol(json_data)

	# Print the line protocol output
	print(line_protocol)

if __name__ == "__main__":
	main()