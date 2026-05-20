#!/bin/bash

# ==========================================================
# Failed Login Summarizer
# Author: Jerome Nance
# Purpose: Summarize failed login attempts from Linux authentication logs
# ==========================================================

REPORT_DIR="$HOME/failed_login_reports"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/failed_login_summary_$DATE.txt"

AUTH_LOG="/var/log/auth.log"

mkdir -p "$REPORT_DIR"

echo "========================================" > "$REPORT_FILE"
echo "Failed Login Summary Report" >> "$REPORT_FILE"
echo "Generated at: $DATE" >> "$REPORT_FILE"
echo "Hostname: $(hostname)" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check if auth log exists
if [ ! -f "$AUTH_LOG" ]; then
    echo "ERROR: Authentication log not found at $AUTH_LOG" >> "$REPORT_FILE"
    echo "This script is designed for Ubuntu/Debian systems using /var/log/auth.log." >> "$REPORT_FILE"
    echo "Failed login summary could not be completed."
    echo "Report saved to: $REPORT_FILE"
    exit 1
fi

echo "[1] Total Failed Password Attempts" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
FAILED_COUNT=$(sudo grep -i "Failed password" "$AUTH_LOG" | wc -l)
echo "Total failed password attempts: $FAILED_COUNT" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[2] Failed Login Attempts by Username" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
sudo grep -i "Failed password" "$AUTH_LOG" | awk '
{
    for (i=1; i<=NF; i++) {
        if ($i == "for") {
            print $(i+1)
        }
    }
}' | sort | uniq -c | sort -nr >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[3] Failed Login Attempts by IP Address" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
sudo grep -i "Failed password" "$AUTH_LOG" | awk '
{
    for (i=1; i<=NF; i++) {
        if ($i == "from") {
            print $(i+1)
        }
    }
}' | sort | uniq -c | sort -nr >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[4] Top 10 Failed Login Lines" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
sudo grep -i "Failed password" "$AUTH_LOG" | tail -10 >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[5] Invalid User Attempts" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
INVALID_COUNT=$(sudo grep -i "Invalid user" "$AUTH_LOG" | wc -l)
echo "Total invalid user attempts: $INVALID_COUNT" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[6] Invalid Usernames Tried" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
sudo grep -i "Invalid user" "$AUTH_LOG" | awk '
{
    for (i=1; i<=NF; i++) {
        if ($i == "user") {
            print $(i+1)
        }
    }
}' | sort | uniq -c | sort -nr >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "========================================" >> "$REPORT_FILE"
echo "Failed login summary complete." >> "$REPORT_FILE"
echo "Report saved to: $REPORT_FILE" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"

echo "Failed login summary complete."
echo "Report saved to: $REPORT_FILE"