#!/bin/bash
set -ex
USERNAME=kj54321
# image name
IMAGE=docker-openconnect-gp
docker build -t $USERNAME/$IMAGE:latest .
