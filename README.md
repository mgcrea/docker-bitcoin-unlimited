# docker-bitcoin-unlimited [![Docker Pulls](https://img.shields.io/docker/pulls/mgcrea/bitcoin-unlimited.svg)](https://registry.hub.docker.com/u/mgcrea/bitcoin-unlimited/)

Run bitcoin-unlimited from a docker container

Based on `ubuntu:16.04` image, run as `www-data` user with [gosu](https://github.com/tianon/gosu).

## Install

```sh
docker pull mgcrea/bitcoin-unlimited:1
```

## Usage

```sh
docker run -d --restart=always \
  -v $(pwd)/data:/var/bitcoin \
  --name bitcoin_unlimited \
  mgcrea/bitcoin-unlimited:1
```

```sh
docker-compose up -d
```

### User/Group override

You can easily override the user/group used by the image using environment variables. Like in the following compose example:

```yaml
# https://docs.docker.com/compose/yml/

bitcoin-unlimited:
  container_name: node
  hostname: node
  image: mgcrea/bitcoin-unlimited:1
  ports:
    - "8333:8333"
  volumes:
    - ./data:/var/bitcoin
  restart: always
```

**NOTE**: for security reasons, starting this docker container will change the permissions of all files in your /var/bitcoin directory to a new, docker-only user. This ensures that the docker container can access the files.

## Debug

Create and inspect a new container

```sh
make bash
```

Inspect a running container

```sh
docker exec -it $CONTAINER_NAME script -q -c "TERM=xterm /bin/bash" /dev/null
```
