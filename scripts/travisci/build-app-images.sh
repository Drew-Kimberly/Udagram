#! /bin/bash

npm run build-images
docker login -u "${DOCKER_REGISTRY_USER}" -p "${DOCKER_REGISTRY_PASS}"
npm run push-images
