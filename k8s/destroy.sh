#! /bin/bash

APPS_DIR="$(dirname $(realpath $0))/apps"

for app in "$APPS_DIR"/*
do
  for resource in "$app"/*
  do
    kubectl delete -f $resource
  done
done
