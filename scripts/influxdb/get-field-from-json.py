import json
import argparse
import sys

def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description="Extract a field from JSON input (file or pipe).")

    # Add field name argument (required)
    parser.add_argument('field_name', type=str, help="The field name to extract from the JSON")

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

    # Extract the value of the specified field
    field_value = data.get(args.field_name)

    if field_value is not None:
        # Print the value of the field
        print(f'The value of "{args.field_name}" is: {field_value}')
    else:
        print(f'Field "{args.field_name}" not found in the JSON data.')

if __name__ == "__main__":
    main()
