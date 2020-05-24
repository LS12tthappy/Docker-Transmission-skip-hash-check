# Transmission-skip-hash-check

```
https://hub.docker.com/r/ls12/transmission-skip-hash-check
```

## Docker image:

`docker pull ls12/shadowsocks-privoxy`

The container can be run using the following command:

```shell
docker docker create
--name=transmission
-e PUID=1000
-e PGID=1000
-e TZ=Asia/Shanghai
-e TRANSMISSION_WEB_HOME=/transmission-web-control/ #optional
-p 9091:9091
-p 51413:51413
-p 51413:51413/udp
-v config:/config
-v downloads:/downloads
-v watch:/watch
--restart unless-stopped
ls12/transmission-skip-hash-check
```

Or `docker-compose.yml`

```
version: "3.3"
services:
  transmission:
    image: ls12/transmission-skip-hash-check
    container_name: transmission
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - TRANSMISSION_WEB_HOME=/transmission-web-control/ #optional
      - USER=username #optional
      - PASS=password #optional
    volumes:
      - path to data:/config
      - path to downloads:/downloads
      - path to watch folder:/watch
    ports:
      - 9091:9091
      - 51413:51413
      - 51413:51413/udp
    restart: unless-stopped
```

## Variables:

```
set variables: 
TRANSMISSION_WEB_HOME=                  /combustion-release/
                                        /transmission-web-control/
                                        
```

Thanks [transmission](https://github.com/transmission/transmission) and [linuxserver](https://github.com/linuxserver/docker-transmission)
