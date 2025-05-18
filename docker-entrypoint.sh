#docker-entrypoint
#!/bin/bash

# Docker entrypoint script
# This script ensures passwords are set correctly before starting SSH

# Run the password setup script
/usr/local/bin/setup-passwords.sh

# Show the current password being used
PASSWORD=${SSH_PASSWORD:-$DEFAULT_PASSWORD}
echo "Current password for both root and sshuser: $PASSWORD"

# Check if SSH server keys exist, generate if they don't
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "SSH host keys not found, generating them..."
    ssh-keygen -A
fi

# Start SSH server
echo "Starting SSH server..."
exec /usr/sbin/sshd -D
