import json
import argparse
import sys

def find_field(data, field_name):
    """
    Recursively search for the field_name in a nested JSON object.
    """
    if isinstance(data, dict):
        # If it's a dictionary, iterate over the keys
        for key, value in data.items():
            if key == field_name:
                return value
            # Recur for nested dictionaries and lists
            result = find_field(value, field_name)
            if result is not None:
                return result
    elif isinstance(data, list):
        # If it's a list, iterate over the elements
        for item in data:
            result = find_field(item, field_name)
            if result is not None:
                return result
    # If the field is not found
    return None

def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description="Extract a nested field from JSON input (file or pipe).")

    # Add field name argument (required)
    parser.add_argument('field_name', type=str, help="The field name to extract from the JSON (searches recursively)")

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

    # Search for the field value recursively
    field_value = find_field(data, args.field_name)

    if field_value is not None:
        # Print the value of the field
        print(f'The value of "{args.field_name}" is: {field_value}')
    else:
        print(f'Field "{args.field_name}" not found in the JSON data.')

if __name__ == "__main__":
    main()