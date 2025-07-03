# Use official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites (only tools, no ELK components)
RUN apt-get update && apt-get install -y \
    curl \
    docker.io \
    docker-compose \
    openjdk-17-jdk \
    openssl \
    net-tools \
    vim \
    less \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /elk-stack

# Copy configuration files (without auto-starting)
COPY . .

# Create directories and set proper permissions for ELK stack
RUN mkdir -p data/elasticsearch data/kibana data/logstash logs \
    && mkdir -p config certs \
    && chmod 755 data/elasticsearch data/kibana data/logstash logs \
    && chmod 644 config/* 2>/dev/null || true \
    && chmod 644 certs/* 2>/dev/null || true \
    && chmod +x entrypoint.sh 2>/dev/null || true

# Create a user group for elasticsearch (UID 1000 is standard for elasticsearch)
RUN groupadd -g 1000 elasticsearch \
    && useradd -u 1000 -g 1000 -s /bin/bash elasticsearch

# Set ownership for data directories
RUN chown -R 1000:1000 data/ config/ certs/ logs/ \
    && chmod -R 755 data/ \
    && chmod -R 644 config/ certs/ 2>/dev/null || true

# Change entrypoint to just start bash shell
ENTRYPOINT ["/bin/bash"]