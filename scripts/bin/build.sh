#! /bin/bash

IMAGE_REPOSITORY="$1"
DOCKERFILE="$2"
BUILD_CONTEXT="$3"
IMAGE_TAG="$4"

tag_args="-t $IMAGE_REPOSITORY"
if [ -n "$IMAGE_TAG" ]
then
  tag_args="$tag_args -t $IMAGE_REPOSITORY:$IMAGE_TAG"
fi

docker build $tag_args -f $DOCKERFILE $BUILD_CONTEXT
