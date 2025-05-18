#!/bin/bash

# Build the Docker image
docker build -t ssh-server .

# Run the container with port forwarding
docker run -d --name ssh-container -p 2222:22 ssh-server

# Wait for the container to start
sleep 2

# Show connection information
echo "SSH server is running!"
echo "Connect with: ssh root@localhost -p 2222"
echo "Password: root_password"

# Optionally test the connection
echo -e "\nTesting connection to SSH server..."
ssh -o "StrictHostKeyChecking=no" root@localhost -p 2222 "echo 'SSH connection successful!'" || echo "Connection test failed"
