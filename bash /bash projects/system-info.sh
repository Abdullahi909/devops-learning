#!/bin/bash

# ============================================================
# system-info.sh
# Displays basic info about the system
# Usage: ./system-info.sh
# ============================================================

echo "=============================="
echo "   SYSTEM INFORMATION"
echo "=============================="
echo ""

# --- Hostname ---
echo "Hostname:  $(hostname)"

# --- OS ---
if [ -f /etc/os-release ]; then
    os_name=$(grep "PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
    echo "OS:        $os_name"
else
    echo "OS:        $(uname -s)"
fi

# --- Kernel ---
echo "Kernel:    $(uname -r)"

# --- Uptime ---
echo "Uptime:    $(uptime -p 2>/dev/null || echo 'N/A')"

# --- Current user ---
echo "User:      $(whoami)"

# --- Date and time ---
echo "Date:      $(date '+%A %d %B %Y, %H:%M')"

echo ""
echo "=============================="
echo "   HARDWARE"
echo "=============================="
echo ""

# --- CPU cores ---
if [ -f /proc/cpuinfo ]; then
    cpu_cores=$(grep -c "processor" /proc/cpuinfo)
    echo "CPU Cores: $cpu_cores"
else
    echo "CPU Cores: N/A"
fi

# --- Memory ---
if command -v free > /dev/null 2>&1; then
    total_mem=$(free -m | grep "Mem:" | awk '{print $2}')
    used_mem=$(free -m | grep "Mem:" | awk '{print $3}')
    echo "Memory:    ${used_mem}MB / ${total_mem}MB"
else
    echo "Memory:    N/A"
fi

# --- Disk usage ---
echo ""
echo "Disk Usage:"
df -h / | tail -1 | awk '{print "  Root (/) : " $3 " used / " $2 " total (" $5 " full)"}'

echo ""
echo "=============================="
echo "   NETWORK"
echo "=============================="
echo ""

# --- IP address ---
if command -v ip > /dev/null 2>&1; then
    ip_addr=$(ip -4 addr show | grep "inet " | grep -v "127.0.0.1" | head -1 | awk '{print $2}')
    if [ -n "$ip_addr" ]; then
        echo "IP Address: $ip_addr"
    else
        echo "IP Address: Not found"
    fi
else
    echo "IP Address: N/A (ip command not available)"
fi

echo ""
echo "=============================="
echo "   Done!"
echo "=============================="
