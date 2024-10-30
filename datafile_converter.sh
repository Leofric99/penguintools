#!/bin/bash

# Converts json to csv or csv to json automatically based on the filepath entered by the user.

function json_to_csv() {
    local json_filename="$1"
    local dir_path=$(dirname "$json_filename")
    local base_filename=$(basename "${json_filename%.*}")
    local csv_filename="${dir_path}/${base_filename}.csv"
    local counter=2

    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        echo "jq is required but not installed. Please install jq."
        exit 1
    fi

    # Determine unique CSV filename
    while [ -e "$csv_filename" ]; do
        csv_filename="${dir_path}/${base_filename} (${counter}).csv"
        ((counter++))
    done

    # Extract headers from the first object in the JSON array
    headers=$(jq -r '.[0] | keys_unsorted | @csv' < "$json_filename")

    # Write headers to CSV file
    echo "$headers" > "$csv_filename"

    # Extract rows and append to CSV file
    jq -r '.[] | map(tostring) | @csv' < "$json_filename" >> "$csv_filename"
}

function csv_to_json() {
    local csv_filename="$1"
    local dir_path=$(dirname "$csv_filename")
    local base_filename=$(basename "${csv_filename%.*}")
    local json_filename="${dir_path}/${base_filename}.json"
    local counter=2

    # Check if csvkit is installed
    if ! command -v csvjson &> /dev/null; then
        echo "csvkit is required but not installed. Please install csvkit."
        exit 1
    fi

    # Determine unique JSON filename
    while [ -e "$json_filename" ]; do
        json_filename="${dir_path}/${base_filename} (${counter}).json"
        ((counter++))
    done

    # Convert CSV to JSON with pretty-printing
    csvjson --indent 4 "$csv_filename" > "$json_filename"
}

# Prompt user for file path
read -p "Please specify a json or csv file path: " file_path

# Expand tilde to home directory
expanded_file_path=$(eval echo "$file_path")

# Determine file extension and call appropriate function
extension="${expanded_file_path##*.}"
if [ "$extension" == "json" ]; then
    json_to_csv "$expanded_file_path"
elif [ "$extension" == "csv" ]; then
    csv_to_json "$expanded_file_path"
else
    echo "Unsupported file type. Please provide a .json or .csv file."
    exit 1
fi