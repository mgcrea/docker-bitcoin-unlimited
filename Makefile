DOCKER_IMAGE := mgcrea/bitcoin-unlimited
IMAGE_VERSION := 1.0.1.3
IMAGE_VERSION_HASH := 864908c88d6b9d08c64e46b12acb5c1f8418b0737dfbeffdb8b1c03907892b02
BASE_IMAGE := ubuntu:16.04

all: build

run:
	@docker run --rm --volume `pwd`/data:/var/bitcoin -it ${DOCKER_IMAGE}:latest

bash:
	@docker run --rm -it ${DOCKER_IMAGE}:latest /bin/bash

build:
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg IMAGE_VERSION_HASH=${IMAGE_VERSION_HASH} --tag=${DOCKER_IMAGE}:latest .

base:
	@docker pull ${BASE_IMAGE}

rebuild: base
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg IMAGE_VERSION_HASH=${IMAGE_VERSION_HASH} --tag=${DOCKER_IMAGE}:latest .

release: rebuild
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg IMAGE_VERSION_HASH=${IMAGE_VERSION_HASH} --tag=${DOCKER_IMAGE}:${IMAGE_VERSION} .
	@scripts/tag.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}

push:
	@scripts/push.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}
