FROM linuxserver/transmission:latest
MAINTAINER Ls12 <i@ls12.me>

ARG TR_VERSION=3.00
ARG LIBEVENT_VERSION=2.1.11
LABEL build_version="transmission-skip-hash-check version:- $TR_VERSION"

# install packages
RUN \
 apk add --no-cache \
  findutils \
  openssl \
  transmission-cli \
  transmission-daemon \
  curl-dev \
  libressl-dev \
  ca-certificates \
  g++ \
  gcc \
  libc-dev \
  make \
  cmake \
  python \
  intltool \
  xz \
  file \
  patch && \
 mkdir /transmission-build && \
 cd /transmission-build && \
 wget -O libevent-$LIBEVENT_VERSION.tar.gz https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION-stable/libevent-$LIBEVENT_VERSION-stable.tar.gz && \
 tar zxvf libevent-$LIBEVENT_VERSION.tar.gz && \
 cd libevent-$LIBEVENT_VERSION-stable && \
 mkdir build && \
 cd build && \
 CFLAGS="-Os -march=native" ../configure && \
 make && \
 make install && \
 cd /transmission-build && \
 wget https://github.com/transmission/transmission-releases/raw/master/transmission-$TR_VERSION.tar.xz && \
 tar -Jxf transmission-$TR_VERSION.tar.xz && \
 cd transmission-$TR_VERSION && \
 wget -O libtransmission/rpcimpl.c https://raw.githubusercontent.com/LS12tthappy/Docker-Transmission-skip-hash-check/master/patch/$TR_VERSION/libtransmission/rpcimpl.c &&\
 wget -O libtransmission/verify.c https://raw.githubusercontent.com/LS12tthappy/Docker-Transmission-skip-hash-check/master/patch/$TR_VERSION/libtransmission/verify.c &&\
 mkdir build && \
 cd build && \
 CFLAGS="-Os -march=native" ../configure && \
 make && \
 make -C cli && \
 apk del \
  ca-certificates \
  curl-dev \
  libressl-dev \
  g++ \
  gcc \
  libc-dev \
  make \
  cmake \
  python \
  intltool \
  xz \
  file \
  coreutils \
  patch && \
 cp /transmission-build/transmission-$TR_VERSION/build/daemon/transmission-daemon /usr/bin/ && \
 cp /transmission-build/transmission-$TR_VERSION/build/cli/transmission-cli /usr/bin/ && \
 rm -rf /transmission-build

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch
