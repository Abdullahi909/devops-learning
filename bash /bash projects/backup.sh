#!/bin/bash

# ============================================================
# backup.sh
# Creates a timestamped backup of a folder
# Usage: ./backup.sh /path/to/folder /path/to/backup-location
# ============================================================

# --- Check arguments ---
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./backup.sh /source/folder /backup/location"
    echo ""
    echo "Example: ./backup.sh /home/abz/projects /home/abz/backups"
    exit 1
fi

SOURCE="$1"
BACKUP_DIR="$2"

# --- Check source exists ---
if [ ! -d "$SOURCE" ]; then
    echo "Error: Source folder '$SOURCE' does not exist."
    exit 1
fi

# --- Create backup directory if needed ---
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Created backup directory: $BACKUP_DIR"
fi

# --- Create timestamp ---
timestamp=$(date '+%Y-%m-%d_%H%M%S')
folder_name=$(basename "$SOURCE")
backup_file="$BACKUP_DIR/${folder_name}_backup_${timestamp}.tar.gz"

# --- Run the backup ---
echo "Starting backup..."
echo "Source:      $SOURCE"
echo "Destination: $backup_file"
echo ""

tar -czf "$backup_file" -C "$(dirname "$SOURCE")" "$folder_name" 2>/dev/null

# --- Check if it worked ---
if [ $? -eq 0 ]; then
    file_size=$(du -h "$backup_file" | awk '{print $1}')
    echo "Backup complete!"
    echo "File: $backup_file"
    echo "Size: $file_size"
else
    echo "Error: Backup failed."
    exit 1
fi

# --- Show recent backups ---
echo ""
echo "Recent backups in $BACKUP_DIR:"
ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -5 | awk '{print "  " $NF " (" $5 ")"}'
