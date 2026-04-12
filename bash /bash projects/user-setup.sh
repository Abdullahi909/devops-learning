#!/bin/bash

# ============================================================
# user-setup.sh
# Creates a new user, adds them to a group, and sets up a home directory
# Must be run as root/sudo
# Usage: sudo ./user-setup.sh
# ============================================================

# --- Check if running as root ---
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root."
    echo "Usage: sudo ./user-setup.sh"
    exit 1
fi

# --- Get username ---
read -p "Enter new username: " username

# Check if user already exists
if id "$username" > /dev/null 2>&1; then
    echo "Error: User '$username' already exists."
    exit 1
fi

# --- Get group ---
read -p "Enter group name (leave blank for default): " groupname

# --- Create group if it doesn't exist ---
if [ -n "$groupname" ]; then
    if ! getent group "$groupname" > /dev/null 2>&1; then
        groupadd "$groupname"
        echo "Created group: $groupname"
    fi
fi

# --- Create the user ---
if [ -n "$groupname" ]; then
    useradd -m -g "$groupname" -s /bin/bash "$username"
else
    useradd -m -s /bin/bash "$username"
fi

echo "Created user: $username"

# --- Set password ---
echo "Set a password for $username:"
passwd "$username"

# --- Create some default directories ---
home_dir="/home/$username"

for folder in Documents Scripts Projects; do
    mkdir -p "$home_dir/$folder"
    echo "Created: $home_dir/$folder"
done

# --- Set ownership ---
chown -R "$username":"${groupname:-$username}" "$home_dir"

echo ""
echo "-----------------------------------"
echo "User setup complete!"
echo "Username:  $username"
echo "Home:      $home_dir"
echo "Shell:     /bin/bash"
if [ -n "$groupname" ]; then
    echo "Group:     $groupname"
fi
echo "-----------------------------------"
