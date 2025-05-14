#!/bin/bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/databases
docker-compose up -d
echo "Database services started!"
echo "PostgreSQL: localhost:5432 (user: bootdev, password: bootdev, database: bootdevdb)"
echo "MySQL: localhost:3306 (user: bootdev, password: bootdev, database: bootdevdb)"
echo "Adminer: http://localhost:8080"
