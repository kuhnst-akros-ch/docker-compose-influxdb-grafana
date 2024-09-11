import json
import argparse
import sys
from collections.abc import MutableMapping

def flatten_json(nested_json, parent_key='', sep='_'):
	"""
	Flattens a nested JSON object.
	"""
	items = []
	for key, value in nested_json.items():
		new_key = f"{parent_key}{sep}{key}" if parent_key else key
		if isinstance(value, MutableMapping):
			items.extend(flatten_json(value, new_key, sep=sep).items())
		else:
			items.append((new_key, value))
	return dict(items)

def sanitize_value(value):
	"""
	Escapes special characters like commas and spaces in field values to prevent issues with line protocol.
	"""
	if isinstance(value, str):
		value = value.replace(',', '\\,').replace(' ', '\\ ')
	return value

def classify_keys(flattened_json):
	"""
	Classifies all key-value pairs into tags, fields, and selects the first key as a measurement.
	"""
	tags = {}
	fields = {}

	# Dynamically select the first key to be the measurement (we don't assume any key name)
	measurement_key, measurement_value = None, None

	# Iterate through all key-value pairs and classify them
	for key, value in flattened_json.items():
		if measurement_key is None:
			measurement_key = key
			measurement_value = value
			continue

		# Classify based on value type: assume strings and booleans are tags, numbers are fields
		if isinstance(value, (str, bool)):
			tags[key] = value
		elif isinstance(value, (int, float)):
			fields[key] = value
		else:
			# You can handle other types here as necessary
			fields[key] = sanitize_value(str(value))

	return measurement_key, measurement_value, tags, fields

def json_to_line_protocol(data):
	"""
	Convert JSON data to InfluxDB line protocol dynamically.
	"""
	flattened_data = flatten_json(data)

	# Classify the flattened data into measurement, tags, and fields
	measurement_key, measurement_value, tags, fields = classify_keys(flattened_data)

	# Construct tags part
	tag_str = ','.join([f"{key}={sanitize_value(str(value))}" for key, value in tags.items()])

	# Sanitize and construct fields part
	field_str = ','.join([f"{key}={sanitize_value(value)}" for key, value in fields.items()])

	# Build line protocol with measurement (no timestamp assumed)
	line_protocol = f"{measurement_key},{tag_str} {field_str}"

	return line_protocol

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

	# Convert JSON to line protocol
	line_protocol = json_to_line_protocol(json_data)

	# Print the line protocol output
	print(line_protocol)

if __name__ == "__main__":
	main()