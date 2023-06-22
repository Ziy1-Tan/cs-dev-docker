# ColumnStore Dev Docker

## Contents

- Dockerfile
- zsh config
- vim config
- scripts for start service and install dependencies

## Setup

```shell
docker build -t columnstore-dev:rockylinux-8 .
git clone https://github.com/MariaDB/server.git --recurse-submodules --depth=1
docker run --privileged -d --name='cs-dev' \
  -v path/to/server:/root/server \
  columnstore-dev:rockylinux-8 /usr/sbin/init
docker exec -it -w /root/server/storage/columnstore/columnstore/build cs-dev /bin/zsh
git checkout develop
. /opt/rh/gcc-toolset-12/enable && ./bootstrap_mcs.sh -D -t Debug -d Rocky
```
