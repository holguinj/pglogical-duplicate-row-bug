#!/bin/bash

cd primary
docker kill pg_primary
docker rm pg_primary
docker build -t pg-primary . # --no-cache
docker run -d -p 127.0.0.1:5434:5432 --restart=always --name pg_primary pg-primary
