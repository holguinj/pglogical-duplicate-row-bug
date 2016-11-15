#!/bin/bash

cd primary
docker kill pg_primary
docker rm pg_primary
docker build --no-cache -t pg-primary .

cd ../replica
docker kill pg_replica
docker rm pg_replica
docker build -t pg-replica .
