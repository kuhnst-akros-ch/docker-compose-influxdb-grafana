import json
import argparse
import sys

def remove_at_keys(data):
	"""
	Recursively remove keys starting with '@' from a JSON object.
	"""
	if isinstance(data, dict):
		# Create a new dictionary without the keys starting with '@'
		return {key: remove_at_keys(value) for key, value in data.items() if not key.startswith('@')}
	elif isinstance(data, list):
		# Recursively apply the function to each item in the list
		return [remove_at_keys(item) for item in data]
	else:
		# If it's not a dictionary or a list, return the value as is
		return data

def main():
	# Create argument parser
	parser = argparse.ArgumentParser(description="Remove all keys starting with '@' from JSON input (file or pipe).")

	# Add file path argument (optional, can be stdin)
	parser.add_argument('file_path', nargs='?', type=str, help="The path to the JSON file (optional if piped input)")

	# Parse the arguments
	args = parser.parse_args()

	# Load JSON from file or stdin (pipe)
	if args.file_path:
		with open(args.file_path, 'r') as file:
			data = json.load(file)
	else:
		# Load JSON from stdin (pipe)
		data = json.load(sys.stdin)

	# Remove all keys starting with '@'
	cleaned_data = remove_at_keys(data)

	# Output the cleaned JSON
	print(json.dumps(cleaned_data, indent=4))

if __name__ == "__main__":
	main()