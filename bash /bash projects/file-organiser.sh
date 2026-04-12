#!/bin/bash

# ============================================================
# file-organiser.sh
# Sorts files in a directory into folders by file extension
# Usage: ./file-organiser.sh /path/to/messy-folder
# ============================================================

# --- Check if a folder path was given ---
if [ -z "$1" ]; then
    echo "Error: No folder path provided."
    echo "Usage: ./file-organiser.sh /path/to/folder"
    exit 1
fi

TARGET_DIR="$1"

# --- Check if the folder exists ---
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a valid directory."
    exit 1
fi

echo "Organising files in: $TARGET_DIR"
echo "-----------------------------------"

moved_count=0
skipped_count=0

# --- Loop through all files in the directory ---
for file in "$TARGET_DIR"/*; do

    # Skip if it's a directory, not a file
    if [ -d "$file" ]; then
        continue
    fi

    # Get the filename and extension
    filename=$(basename "$file")
    extension="${filename##*.}"

    # Skip files with no extension
    if [ "$filename" = "$extension" ]; then
        echo "Skipped (no extension): $filename"
        skipped_count=$((skipped_count + 1))
        continue
    fi

    # Make extension lowercase
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

    # Create the folder for this extension if it doesn't exist
    folder="$TARGET_DIR/$extension-files"
    if [ ! -d "$folder" ]; then
        mkdir "$folder"
        echo "Created folder: $extension-files/"
    fi

    # Move the file
    mv "$file" "$folder/"
    echo "Moved: $filename -> $extension-files/"
    moved_count=$((moved_count + 1))

done

echo "-----------------------------------"
echo "Done! Moved $moved_count file(s). Skipped $skipped_count file(s)."
