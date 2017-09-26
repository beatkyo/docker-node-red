#!/bin/bash
set -e

source "version"

ARCH=${1:-$(uname -m)}

function build {
  echo
  echo "+ build"
  echo "+ arch: ${ARCH:?}"
  echo "+ image: ${IMAGE:?}"
  echo "+ version: ${VERSION:?}"
  echo

  export IMAGE
  export VERSION

  docker build \
    --pull \
    --build-arg "IMAGE=$IMAGE" \
    --build-arg "VERSION=$VERSION" \
    --tag "dalexandre/node-red-$ARCH:$VERSION" \
    --tag "dalexandre/node-red-$ARCH:latest" \
    .
}

function build-i386 {
  ARCH="i386"
  IMAGE="i386/node:8"

  build
}

function build-amd64 {
  ARCH="amd64"
  IMAGE="amd64/node:8"

  build
}

function build-aarch64 {
  ARCH="arm64v8"
  IMAGE="arm64v8/node:8"

  build
}

function build-x86_64 { 
  build-amd64 
}

build-${ARCH:?}