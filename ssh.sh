#!/data/data/com.termux/files/usr/bin/bash

# Script to set up SSH server on Termux and make it accessible on both local network and public internet via static IP
# Usage: bash setup_termux_ssh.sh

echo "Setting up SSH server on Termux for local and public internet access..."

# Check if required packages are installed
if ! command -v sshd &> /dev/null || ! command -v curl &> /dev/null; then
    echo "Installing required packages..."
    pkg update -y
    pkg install -y openssh curl

    if [ $? -ne 0 ]; then
        echo "Failed to install required packages. Please check your internet connection and try again."
        exit 1
    fi
    echo "Required packages installed successfully."
else
    echo "Required packages are already installed."
fi

# Generate SSH keys if they don't exist
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Generating SSH keys..."
    ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
    echo "SSH keys generated."
else
    echo "SSH keys already exist."
fi

# Configure sshd_config to allow password authentication
SSHD_CONFIG="$PREFIX/etc/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
    # Enable password authentication if not already enabled
    if grep -q "^PasswordAuthentication" "$SSHD_CONFIG"; then
        sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' "$SSHD_CONFIG"
    else
        echo "PasswordAuthentication yes" >> "$SSHD_CONFIG"
    fi
    echo "SSH configured to allow password authentication."
fi

# Set or change password if needed
echo "Do you want to set/change your Termux password? (y/n)"
read -r set_password
if [[ "$set_password" =~ ^[Yy]$ ]]; then
    passwd
    echo "Password updated."
fi

# Start or restart SSH server
pkill sshd || true
sshd
if [ $? -ne 0 ]; then
    echo "Failed to start SSH server. Check for errors above."
    exit 1
fi
echo "SSH server started."

# Get device IP on the local network
LOCAL_IP=$(ip -o -4 addr list | grep -v "127.0.0.1" | awk '{print $4}' | cut -d/ -f1 | head -n1)

# Get public IP address
echo "Fetching your public IP address..."
PUBLIC_IP=$(curl -s https://api.ipify.org)

# Display connection information
echo -e "\n======================= SSH ACCESS INFO =========================="
echo "SSH server is running!"

if [ -n "$LOCAL_IP" ]; then
    echo -e "\nLOCAL NETWORK ACCESS:"
    echo "SSH Address: ${LOCAL_IP}"
    echo "SSH Port: 8022 (Termux default SSH port)"
    echo "Command: ssh $USER@${LOCAL_IP} -p 8022"
fi

if [ -n "$PUBLIC_IP" ]; then
    echo -e "\nPUBLIC INTERNET ACCESS:"
    echo "Your public IP address is: ${PUBLIC_IP}"
    echo "SSH Port: 8022 (Needs port forwarding on your router)"
    echo "Command: ssh $USER@${PUBLIC_IP} -p <FORWARDED_PORT>"
    echo -e "\nIMPORTANT STEPS FOR PUBLIC ACCESS:"
    echo "1. Configure port forwarding on your router to forward an external port"
    echo "   (e.g., 2222) to ${LOCAL_IP}:8022"
    echo "2. Ensure your ISP isn't blocking incoming connections on your chosen port"
    echo "3. Consider setting up a stronger password or key-only authentication"
    echo "   before exposing SSH to the internet"
fi

echo -e "\n=================================================================="
echo "To stop the SSH server later, run: 'pkill sshd'"
