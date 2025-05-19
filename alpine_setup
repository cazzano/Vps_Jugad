# Use Alpine Linux for a smaller footprint
FROM alpine:latest

# Install OpenSSH and other necessary packages
RUN apk update && \
    apk add --no-cache openssh bash curl wget git sudo && \
    rm -rf /var/cache/apk/*

# Configure SSH server
RUN mkdir -p /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config && \
    # Generate SSH keys ahead of time to avoid runtime generation
    ssh-keygen -A

# Set root password
ENV ROOT_PASSWORD="root_password"
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# Add a non-root user with sudo privileges
RUN adduser -D -s /bin/bash sshuser && \
    echo "sshuser:${ROOT_PASSWORD}" | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "sshuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sshuser && \
    chmod 0440 /etc/sudoers.d/sshuser

# Create entrypoint script
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'echo "Starting SSH server with root access"' >> /entrypoint.sh && \
    echo 'echo "Root password: ${ROOT_PASSWORD}"' >> /entrypoint.sh && \
    echo 'exec /usr/sbin/sshd -D -e' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose SSH port
EXPOSE 22

# Run SSH daemon
ENTRYPOINT ["/entrypoint.sh"]
