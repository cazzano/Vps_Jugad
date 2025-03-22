# Use an official Ubuntu base image
FROM archlinux:latest

# Set non-interactive mode for apt-get
#ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN pacman -Syyu --needed --noconfirm 
RUN pacman -S wget git curl --needed --noconfirm

# Install sshx
RUN curl -sSf https://sshx.io/get | sh

# Create a directory for potential persistent storage
#RUN mkdir -p /data

# Set the default command to sshx
CMD ["sshx"]
