FROM lsiobase/alpine:3.11
MAINTAINER Ls12 <i@ls12.me>

ARG TR_VERSION=3.00
LABEL build_version="transmission-skip-hash-check version:- $TR_VERSION"

# install packages
RUN \
 apk add --no-cache \
  ca-certificates \
  curl \
  curl-dev \
  libressl-dev \
  g++ \
  gcc \
  libc-dev \
  make \
  cmake \
  intltool \
  libevent-dev \
  patch \
  transmission-cli \
  transmission-daemon && \ 
 mkdir /transmission-build && \
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
 cp /transmission-build/transmission-$TR_VERSION/build/daemon/transmission-daemon /usr/bin/ && \
 cp /transmission-build/transmission-$TR_VERSION/build/cli/transmission-cli /usr/bin/ && \
 rm -rf /transmission-build && \
 curl -o /tmp/combustion.zip -L \
	"https://github.com/Secretmapper/combustion/archive/release.zip" && \
 unzip \
	/tmp/combustion.zip -d \
	/ && \
 mkdir -p /tmp/twctemp && \
 TWCVERSION=$(curl -sX GET "https://api.github.com/repos/ronggang/transmission-web-control/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o /tmp/twc.tar.gz -L \
	"https://github.com/ronggang/transmission-web-control/archive/${TWCVERSION}.tar.gz" && \
 tar xf \
	/tmp/twc.tar.gz -C \
	/tmp/twctemp --strip-components=1 && \
 mv /tmp/twctemp/src /transmission-web-control && \
 mkdir -p /kettu && \
 curl -o /tmp/kettu.tar.gz -L \
	"https://github.com/endor/kettu/archive/master.tar.gz" && \
 tar xf \
	/tmp/kettu.tar.gz -C \
	/kettu --strip-components=1 && \
 rm -rf /tmp/* && \
 apk del \
  curl \
  ca-certificates \
  curl-dev \
  libressl-dev \
  g++ \
  gcc \
  libc-dev \
  make \
  cmake \
  intltool \
  libevent-dev \
  patch 

# copy local files
COPY rootfs/ /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch
