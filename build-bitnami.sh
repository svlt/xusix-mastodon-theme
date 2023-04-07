#!/bin/bash
set -e
docker build -f Dockerfile-bitnami -t alanaktion/xusix-mastodon:4.1.2-bitnami . --pull
docker push alanaktion/xusix-mastodon:4.1.2-bitnami
