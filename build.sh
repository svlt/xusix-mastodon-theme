#!/bin/bash
set -e

# Build and push the Docker image
docker build -f Dockerfile \
    -t ghcr.io/svlt/xusix-mastodon-theme:latest \
    -t docker.io/alanaktion/xusix-mastodon:latest \
    --target production . --pull

docker push ghcr.io/svlt/xusix-mastodon-theme:latest
docker push docker.io/alanaktion/xusix-mastodon:latest
