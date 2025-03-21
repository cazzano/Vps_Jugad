# Use an official Ubuntu base image
FROM alpine:latest

# Set non-interactive mode for apt-get
#ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apk update && apk upgrade --available && apk add curl

# Install sshx
RUN curl -sSf https://sshx.io/get | sh

# Create a directory for potential persistent storage
#RUN mkdir -p /data

# Set the default command to sshx
CMD ["sshx"]
