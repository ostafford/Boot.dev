#!/bin/bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/servers
docker-compose up -d
echo "Web servers started!"
echo "Nginx server: http://localhost:8081"
echo "Node.js server: http://localhost:3000"
