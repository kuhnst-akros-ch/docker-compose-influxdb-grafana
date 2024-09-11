import json
import time
import sys
import os

def flatten_json(nested_json, parent_key='', sep='_'):
	"""Flatten a nested JSON object."""
	items = []
	for k, v in nested_json.items():
		new_key = parent_key + sep + k if parent_key else k
		if isinstance(v, dict):
			items.extend(flatten_json(v, new_key, sep=sep).items())
		else:
			items.append((new_key, v))
	return dict(items)

def convert_json_to_line_protocol(data):
	"""Converts a generic JSON object to InfluxDB line protocol format."""

	# Flatten the JSON data
	flat_data = flatten_json(data)

	# Guess the measurement name and remove it from the fields (if necessary)
	measurement = flat_data.pop("measurement", "default_measurement")

	# Prepare fields, tags, and timestamp
	fields = []
	tags = []
	timestamp = None

	for key, value in flat_data.items():
		if key in ["timestamp", "time"] and isinstance(value, str):
			# Convert timestamp to Unix nanoseconds
			timestamp = int(time.mktime(time.strptime(value, '%Y-%m-%dT%H:%M:%SZ'))) * 1_000_000_000
		elif isinstance(value, (int, float, bool)):
			# Treat numbers and booleans as fields
			fields.append(f'{key}={value}')
		elif isinstance(value, str):
			# Treat strings as tags
			tags.append(f'{key}={value}')

	# Build the line protocol string
	tag_str = ','.join(tags)
	field_str = ','.join(fields)

	# If a timestamp was found, add it; otherwise omit
	if timestamp:
		line_protocol = f'{measurement},{tag_str} {field_str} {timestamp}'
	else:
		line_protocol = f'{measurement},{tag_str} {field_str}'

	return line_protocol

def read_json_from_file(file_path):
	"""Reads JSON data from a file."""
	with open(file_path, 'r') as f:
		return json.load(f)

def read_json_from_pipe():
	"""Reads JSON data from standard input (pipe)."""
	return json.load(sys.stdin)

if __name__ == "__main__":
	# Check if input is provided via a file path or pipe
	if len(sys.argv) > 1:
		# Read JSON from a file
		file_path = sys.argv[1]
		if os.path.exists(file_path):
			data = read_json_from_file(file_path)
		else:
			print(f"File {file_path} does not exist.")
			sys.exit(1)
	elif not sys.stdin.isatty():
		# Read JSON from pipe (standard input)
		data = read_json_from_pipe()
	else:
		print("No input file or pipe provided.")
		sys.exit(1)

	# Convert the JSON data to line protocol
	line_protocol = convert_json_to_line_protocol(data)

	# Print the line protocol
	print(line_protocol)