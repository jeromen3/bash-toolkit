#!/bin/bash

# ==========================================================
# Backup Automation Script
# Author: Jerome Nance
# Purpose: Back up a selected folder, compress it, and log the result
# ==========================================================

# Folder you want to back up
SOURCE_DIR="$HOME/Documents"

# Folder where backups will be stored
BACKUP_DIR="$HOME/backups"

# Date and time for unique backup names
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup file name
BACKUP_NAME="backup_$DATE.tar.gz"

# Log file
LOG_FILE="$BACKUP_DIR/backup.log"

# Create backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Start log entry
echo "========================================" >> "$LOG_FILE"
echo "Backup started at: $DATE" >> "$LOG_FILE"
echo "Source directory: $SOURCE_DIR" >> "$LOG_FILE"
echo "Backup directory: $BACKUP_DIR" >> "$LOG_FILE"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory does not exist: $SOURCE_DIR" >> "$LOG_FILE"
    echo "Backup failed. Source directory does not exist."
    exit 1
fi

# Create compressed backup
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR" 2>> "$LOG_FILE"

# Check if backup succeeded
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_NAME" >> "$LOG_FILE"
    echo "Backup completed successfully."
    echo "Backup saved to: $BACKUP_DIR/$BACKUP_NAME"
else
    echo "ERROR: Backup failed." >> "$LOG_FILE"
    echo "Backup failed. Check the log file."
    exit 1
fi

# Delete backups older than 7 days
find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -mtime +7 -delete

echo "Old backups older than 7 days deleted." >> "$LOG_FILE"
echo "Backup finished at: $(date +"%Y-%m-%d_%H-%M-%S")" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"