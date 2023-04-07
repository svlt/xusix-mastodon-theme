#!/bin/bash
docker build -t alanaktion/xusix-mastodon . --pull
docker push alanaktion/xusix-mastodon:4.1.1
