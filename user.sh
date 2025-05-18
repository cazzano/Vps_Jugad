#!/bin/bash

# Script to create a new user with sudo permissions on Arch Linux
# Usage: sudo bash create_sudo_user.sh

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

# Function to validate username
validate_username() {
    if [[ ! "$1" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        return 1
    fi
    return 0
}

# Prompt for username
while true; do
    read -p "Enter username for the new user: " USERNAME
    if [ -z "$USERNAME" ]; then
        echo "Username cannot be empty. Please try again."
    elif getent passwd "$USERNAME" > /dev/null; then
        echo "User '$USERNAME' already exists. Please choose a different username."
    elif ! validate_username "$USERNAME"; then
        echo "Invalid username. Username must start with a lowercase letter or underscore and can only contain lowercase letters, digits, underscores, and hyphens."
    else
        break
    fi
done

# Create the user
echo "Creating user $USERNAME..."
useradd -m -G wheel -s /bin/bash "$USERNAME"

# Set password
echo "Setting password for $USERNAME..."
passwd "$USERNAME"

# Verify the wheel group is in the sudoers file
if ! grep -q "^%wheel ALL=(ALL) ALL" /etc/sudoers; then
    echo "Configuring sudo access for wheel group..."
    # Enable sudo access for wheel group (uncomment the line if it exists but is commented)
    sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    
    # If the line doesn't exist at all, add it
    if ! grep -q "^%wheel ALL=(ALL) ALL" /etc/sudoers; then
        echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
    fi
fi

echo "User $USERNAME has been created with sudo permissions."
echo "You can now login as $USERNAME with the password you provided."
