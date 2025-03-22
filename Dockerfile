# Use an official Ubuntu base image
FROM arch:latest

# Set non-interactive mode for apt-get
#ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN pacman -Syyu && pacman -S wget git curl

# Install sshx
RUN curl -sSf https://sshx.io/get | sh

# Create a directory for potential persistent storage
#RUN mkdir -p /data

# Set the default command to sshx
CMD ["sshx"]
