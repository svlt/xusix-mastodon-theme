#!/bin/bash
set -e

# Docker Hub
docker build -f bitnami.dockerfile -t alanaktion/xusix-mastodon:4.1.2-bitnami . --pull
docker push alanaktion/xusix-mastodon:4.1.2-bitnami
