#!/bin/bash

# Log Parser v1
# Purpose: Parse authentication logs for useful security events

LOG_FILE="/var/log/auth.log"

echo "================================"
echo "       Log Parser Report        "
echo "================================"
echo "Generated on: $(date)"
echo

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file $LOG_FILE not found."
    exit 1
fi

echo "------LOG FILE BEING ANALYZED------"
echo "File: $LOG_FILE"
echo

echo "------RECENT FAILED LOGIN ATTEMPTS------"
grep -i "failed login" "$LOG_FILE" | tail -n 10
echo

echo "------SUDO COMMAND USAGE-------"
grep -i "sudo" "$LOG_FILE" | tail -n 10
echo

echo "------INVALID USER ATTEMPTS------"
grep -i "invalid user" "$LOG_FILE" | tail -n 10
echo

echo "------ACCEPTED SSH LOGINS------"
grep -i "accepted" "$LOG_FILE" | tail -n 10
echo

echo "================================"
echo "  Report generated successfully "
echo "================================"