FROM ubuntu:16.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ARG IMAGE_VERSION_HASH
ENV IMAGE_VERSION_HASH ${IMAGE_VERSION_HASH:-0}
ENV IMAGE_USER www-data
ENV IMAGE_GROUP www-data
ENV UID 33
ENV GID 33

# apt update
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.9
RUN set -x \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

# install bitcoin
RUN curl -SLO "https://www.bitcoinunlimited.info/downloads/bitcoinUnlimited-${IMAGE_VERSION}-linux64.tar.gz" \
  && echo "${IMAGE_VERSION_HASH} bitcoinUnlimited-${IMAGE_VERSION}-linux64.tar.gz" | sha256sum -c - \
  && tar -xzvf bitcoinUnlimited-${IMAGE_VERSION}-linux64.tar.gz -C /usr/local --strip-components=1 \
  && rm bitcoinUnlimited-${IMAGE_VERSION}-linux64.tar.gz

# apt cleanup 
RUN apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# setup home
RUN mkdir /var/bitcoin \
  && chown $IMAGE_USER:$IMAGE_GROUP /var/bitcoin

# volume
WORKDIR /var/bitcoin
VOLUME ["/var/bitcoin"]
EXPOSE 8333

# entrypoint
ADD ./files/bitcoind /usr/local/sbin/bitcoind
RUN chmod 770 /usr/local/sbin/bitcoind
CMD ["bitcoind", "-printtoconsole", "-datadir=/var/bitcoin", "-dbcache=4000"]
