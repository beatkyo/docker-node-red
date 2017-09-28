#!/bin/bash
set -e

source "version"

ARCH=${1:-$(uname -m)}

function build {
  echo
  echo "+ build"
  echo "+ arch: ${ARCH:?}"
  echo "+ image: ${IMAGE:?}"
  echo "+ node red version: ${NODE_RED_VERSION:?}"
  echo "+ open zwave version: ${ZWAVE_VERSION:?}"
  echo

  export IMAGE
  export NODE_RED_VERSION

  docker build \
    --pull \
    --build-arg "IMAGE=$IMAGE" \
    --build-arg "NODE_RED_VERSION=$NODE_RED_VERSION" \
    --build-arg "ZWAVE_VERSION=$ZWAVE_VERSION" \
    --tag "dalexandre/node-red-$ARCH:$NODE_RED_VERSION" \
    --tag "dalexandre/node-red-$ARCH:latest" \
    .
}

function build-i386 {
  ARCH="i386"
  IMAGE="dalexandre/node-386"

  build
}

function build-amd64 {
  ARCH="amd64"
  IMAGE="dalexandre/node-amd64"

  build
}

function build-aarch64 {
  ARCH="arm64v8"
  IMAGE="dalexandre/node-arm64v8"

  build
}

function build-x86_64 { 
  build-amd64 
}

build-${ARCH:?}