#!/bin/bash
set -e

# Docker Hub
docker build -f Dockerfile-bitnami -t alanaktion/xusix-mastodon:4.1.2-bitnami . --pull
docker push alanaktion/xusix-mastodon:4.1.2-bitnami

# Local microk8s registry
if [[ "$(microk8s status -a registry)" == "enabled" ]]; then
    docker tag alanaktion/xusix-mastodon:4.1.2-bitnami localhost:32000/xusix-mastodon:4.1.2-bitnami
    docker push localhost:32000/xusix-mastodon:4.1.2-bitnami
fi
