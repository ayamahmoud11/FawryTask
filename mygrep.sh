#!/bin/bash

show_line_numbers=false
invert_match=false

# Parse options using getopts
while getopts "nv" opt; do
    case "$opt" in
        n) 
            show_line_numbers=true
            ;;
        v)
            invert_match=true
            ;;
        *)
            echo "Usage: $0 [-n] [-v] search_string filename"
            exit 1
            ;;
    esac
done

# Shift to the position of the search string and file
shift $((OPTIND - 1))

# Get the search string and file name
search="$1"
file="$2"

# Handle --help flag
if [[ "$search" == "--help" ]]; then
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n   Show line numbers (same as -nv)"
    echo "  -v   Invert match (same as -vn)"
    echo "  --help Show this help message"
    exit 0
fi

# Check if search string and file are provided
if [[ -z "$search" || -z "$file" ]]; then
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Error: Missing search string or filename."
    exit 1
fi

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Start searching
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))

    # Invert match logic
    if [[ "$invert_match" == true ]]; then
        if ! echo "$line" | grep -i -q "$search"; then
            if [[ "$show_line_numbers" == true ]]; then
                echo "$line_number:$line"
            else
                echo "$line"
            fi
        fi
    else
        if echo "$line" | grep -i -q "$search"; then
            if [[ "$show_line_numbers" == true ]]; then
                echo "$line_number:$line"
            else
                echo "$line"
            fi
        fi
    fi
done < "$file"
