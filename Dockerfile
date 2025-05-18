# Use an official Arch Linux base image
FROM archlinux:latest

# Install necessary dependencies and OpenSSH
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm openssh wget curl git sudo bash && \
    pacman -Scc --noconfirm

# Set up SSH configuration
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Create a directory for persistent storage
RUN mkdir -p /data

# Set default password - same for root and regular user
ENV DEFAULT_PASSWORD="securepassword"

# Set up a default user with sudo permissions and set root password
RUN useradd -m -G wheel -s /bin/bash sshuser && \
    echo "sshuser:${DEFAULT_PASSWORD}" | chpasswd && \
    echo "root:${DEFAULT_PASSWORD}" | chpasswd && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

# Copy script files with proper line endings
COPY setup-passwords.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

# Make scripts executable
RUN chmod +x /usr/local/bin/setup-passwords.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    # Fix potential line ending issues
    sed -i 's/\r$//' /usr/local/bin/setup-passwords.sh && \
    sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh

# Prompt to change the default password on first login
RUN echo "echo 'Default password for both root and sshuser is: \$DEFAULT_PASSWORD'" >> /home/sshuser/.bashrc && \
    echo "echo 'Please change your password with passwd command for security.'" >> /home/sshuser/.bashrc

# Verify installations
RUN wget --version && \
    curl --version && \
    git --version

# Expose SSH port
EXPOSE 22

# Start SSH server with password validation
ENTRYPOINT ["/bin/bash", "/usr/local/bin/docker-entrypoint.sh"]
