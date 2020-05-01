#! /bin/bash

APPS_DIR="$(dirname $(realpath $0))/apps"

# The image tag provided to deploy (defaults to latest).
IMAGE_TAG="${1:-latest}"
echo "Using image tag: ${IMAGE_TAG}"

for app in "$APPS_DIR"/*
do
  for resource in "$app"/*
  do
    sed "s/{IMAGE_TAG}/$IMAGE_TAG/g" "$resource" | kubectl apply -f -
  done
done
