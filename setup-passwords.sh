#!/bin/bash
set -e

# Setup passwords script
# This script checks and sets passwords for root and sshuser

# Get the password from environment variable or use default
PASSWORD=${SSH_PASSWORD:-$DEFAULT_PASSWORD}

# Function to set password
set_password() {
    local user=$1
    local pass=$2

    # Set password and check if it succeeded
    echo "${user}:${pass}" | chpasswd
    if [ $? -ne 0 ]; then
        echo "Failed to set password for ${user}!"
        return 1
    fi

    echo "Password set successfully for ${user}"
    return 0
}

# Set passwords
set_password "root" "$PASSWORD"
set_password "sshuser" "$PASSWORD"

echo "Passwords configured successfully"
