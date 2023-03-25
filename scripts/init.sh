#!/bin/bash

# Build jenkins infrastructure
docker-compose -f docker/docker-compose.yml build --no-cache
docker-compose -f docker/docker-compose.yml up
