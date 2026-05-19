#!/bin/bash

#====================================================================
# System Audit Script
# Purpose: Collect basic Linux system/admin info
# Author: TuckedRome
#====================================================================

echo "==================================="
echo "         System Audit Script       "
echo "==================================="
echo " Generated on: $(date)"

echo "------HOST INFORMATION------"
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Kernel Version: $(uname -r)"
echo "Operating System:"
grep PRETTY_NAME /etc/os-release | cut -d= -f2 \ tr -d '"'
echo 

echo "-------SYSTEM UPTIME-------"
uptime -p   
echo

echo "-------CPU INFORMATION-------"
lscpu | grep "Model name" \ sed 's/Model name:[ \t]*//'
echo "CPU Cores: $(nproc)"
echo

echo "-------MEMORY USUAGE-------"
free -h
echo

echo "-------TOP 5 MEMORY-CONSUMING PROCESSES-------"
ps aux --sort=-%mem | head -n 6
echo

echo "-------TOP 5 CPU-CONSUMING PROCESSES-------"
ps aux --sort=-%cpu | head -n 6
echo

echo "-------LISTENING NETWORK PORTS-------"
ss -tuln
echo

echo "-------FAILED LOGIN ATTEMPTS-------"
if [ -f /var/log/auth.log ]; then
    grep -i "failed" /var/log/auth.log | tail -n 10
else
    echo "No /var/log/auth.log found."
fi
echo

echo "-------FIREWALL STATUS-------"
if command -v ufw >/dev/null 2>&1; then
    sudo ufw status
else
    echo "UFW not installed."
fi
echo

echo "-------RUNNING SERVICES-------"
systemctl list-units --type=service --state=running
echo

echo "==================================="
echo "         End of System Audit       "
echo "==================================="