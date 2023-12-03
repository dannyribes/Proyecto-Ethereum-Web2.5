#!/bin/bash

# Set the path to your Docker Compose file
DOCKER_COMPOSE_FILE="docker-compose.yml"

# Check if Docker Compose is installed
if command -v docker-compose &> /dev/null
then
    echo "Docker Compose is installed. Running nodes..."
else
    echo "Docker Compose is not installed. Please install it before running this script."
    exit 1
fi

# Run Docker Compose to start the nodes
docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
