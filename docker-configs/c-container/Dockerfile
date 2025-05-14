FROM ubuntu:22.04

# Install C development tools and Valgrind
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    gdb \
    valgrind \
    vim \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a work directory
WORKDIR /code

# Keep container running
CMD ["tail", "-f", "/dev/null"]
