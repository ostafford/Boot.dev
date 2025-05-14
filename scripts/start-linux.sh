#!/bin/bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/linux-playground
docker-compose up -d
echo "Linux containers started!"
echo "To access Ubuntu container: docker exec -it bootdev-ubuntu bash"
echo "To access Alpine container: docker exec -it bootdev-alpine sh"
