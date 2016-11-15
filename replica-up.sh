#!/bin/bash

cd replica
docker kill pg_replica
docker rm pg_replica
docker build -t pg-replica . # --no-cache
docker run -d -p 127.0.0.1:5433:5432 --restart=always --name pg_replica pg-replica
