#!/bin/bash
set -e

# GHCR
docker build -f lscr.dockerfile -t ghcr.io/svlt/xusix-mastodon-theme:latest --target production . --pull
docker push ghcr.io/svlt/xusix-mastodon-theme:latest
