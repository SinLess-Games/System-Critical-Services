#!/bin/bash

docker stack deploy -c cAdvisor/docker-compose.yaml cadvisor
docker stack deploy -c node-exporter/docker-compose.yaml node-exporter
docker stack deploy -c portainer/docker-compose.yaml portainer