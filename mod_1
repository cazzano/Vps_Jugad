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

# Set up a default user with sudo permissions
RUN useradd -m -G wheel -s /bin/bash sshuser && \
    echo "sshuser:password" | chpasswd && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

# Prompt to change the default password on first login
RUN echo "echo 'Please change your password with passwd command for security.'" >> /home/sshuser/.bashrc

# Verify installations
RUN wget --version && \
    curl --version && \
    git --version

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]
