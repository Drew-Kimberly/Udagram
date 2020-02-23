#! /bin/bash

source "../bin/split.sh"

# Ensure the build can push to our repos.
mkdir -p ~/.ssh
echo "${PACKAGE_SPLIT_SSH_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
ssh-keyscan -H 'github.com' >> ~/.ssh/known_hosts

# Split monorepo packages.
split_ci_job "udagram-frontend" "packages/udagram-frontend"
split_ci_job "udagram-feed-svc" "packages/udagram-feed-svc"
split_ci_job "udagram-user-svc" "packages/udagram-user-svc"
split_ci_job "udagram-auth" "packages/udagram-auth"
