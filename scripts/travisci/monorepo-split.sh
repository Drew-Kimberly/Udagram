#! /bin/bash

source "$(dirname $(dirname $(realpath $0)))/bin/split.sh"

# Split monorepo packages.
split_package "udagram-frontend" "packages/udagram-frontend"
split_package "udagram-feed-svc" "packages/udagram-feed-svc"
split_package "udagram-user-svc" "packages/udagram-user-svc"
split_package "udagram-auth" "packages/udagram-auth"
