# Use an official Ubuntu base image
FROM archlinux:latest

# Set non-interactive mode for apt-get
#ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm wget curl git

# Verify installations
RUN wget --version && \
    curl --version && \
    git --version


# Install sshx
RUN curl -sSf https://sshx.io/get | sh

# Create a directory for potential persistent storage
#RUN mkdir -p /data

# Set the default command to sshx
CMD ["sshx"]
