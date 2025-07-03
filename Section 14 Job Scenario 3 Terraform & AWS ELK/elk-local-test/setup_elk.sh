#!/bin/bash

echo "Setting up ELK Stack..."

# Create directory structure
echo "Creating directories..."
mkdir -p data/{elasticsearch,kibana,filebeat,metricbeat,logstash}
mkdir -p config certs logs

# Create config files if they don't exist
echo "Creating configuration files..."

# Create filebeat.yml
cat > config/filebeat.yml << 'EOF'
filebeat.inputs:
- type: container
  paths:
    - '/var/lib/docker/containers/*/*.log'

processors:
- add_docker_metadata:
    host: "unix:///var/run/docker.sock"
- decode_json_fields:
    fields: ["message"]
    target: ""
    overwrite_keys: true

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
  indices:
    - index: "filebeat-docker-logs-%{+yyyy.MM.dd}"

logging.level: info
logging.to_files: true
logging.files:
  path: /usr/share/filebeat/logs
  name: filebeat
  keepfiles: 7
  permissions: 0644
EOF

# Create metricbeat.yml
cat > config/metricbeat.yml << 'EOF'
metricbeat.modules:
- module: docker
  metricsets:
    - "container"
    - "cpu"
    - "diskio"
    - "healthcheck"
    - "info"
    - "memory"
    - "network"
  hosts: ["unix:///var/run/docker.sock"]
  period: 10s
  enabled: true

- module: system
  metricsets:
    - cpu
    - load
    - memory
    - network
    - process
    - process_summary
  enabled: true
  period: 10s
  processes: ['.*']

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
  indices:
    - index: "metricbeat-docker-metrics-%{+yyyy.MM.dd}"

processors:
- add_host_metadata:
    when.not.contains.tags: forwarded
- add_docker_metadata: ~

logging.level: info
logging.to_files: true
logging.files:
  path: /usr/share/metricbeat/logs
  name: metricbeat
  keepfiles: 7
  permissions: 0644
EOF

# Set permissions
echo "Setting permissions..."
chmod -R 777 data/
chmod -R 755 config/ certs/ logs/
chmod 644 config/*.yml

echo "Setup complete!"
echo "Directory structure:"
ls -la data/
echo "Config files:"
ls -la config/

echo ""
echo "Now you can run:"
echo "docker-compose up -d"