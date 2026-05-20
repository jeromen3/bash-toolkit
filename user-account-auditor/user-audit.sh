#!/bin/bash

# ==========================================================
# User Account Auditor
# Author: Jerome Nance
# Purpose: Audit local Linux user accounts and identify security-relevant account details
# ==========================================================

REPORT_DIR="$HOME/user_audit_reports"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/user_audit_$DATE.txt"

mkdir -p "$REPORT_DIR"

echo "========================================" > "$REPORT_FILE"
echo "User Account Audit Report" >> "$REPORT_FILE"
echo "Generated at: $DATE" >> "$REPORT_FILE"
echo "Hostname: $(hostname)" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[1] All Local User Accounts" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
cut -d: -f1 /etc/passwd >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[2] Users With Login Shells" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
awk -F: '$7 !~ /(nologin|false)$/ {print $1 " - " $7}' /etc/passwd >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[3] Users With UID 0" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
awk -F: '$3 == 0 {print $1 " - UID: " $3}' /etc/passwd >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[4] Users With Sudo Group Access" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
getent group sudo >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[5] Locked Accounts" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
sudo awk -F: '$2 ~ /^!/ {print $1 " - locked"}' /etc/shadow >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[6] Accounts With Empty Password Field" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"
sudo awk -F: '$2 == "" {print $1 " - WARNING: empty password field"}' /etc/shadow >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "[7] Password Aging Information" >> "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"

for user in $(awk -F: '$7 !~ /(nologin|false)$/ {print $1}' /etc/passwd); do
    echo "User: $user" >> "$REPORT_FILE"
    sudo chage -l "$user" >> "$REPORT_FILE" 2>/dev/null
    echo "" >> "$REPORT_FILE"
done

echo "========================================" >> "$REPORT_FILE"
echo "Audit complete." >> "$REPORT_FILE"
echo "Report saved to: $REPORT_FILE" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"

echo "User account audit complete."
echo "Report saved to: $REPORT_FILE"