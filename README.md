# ColumnStore Dev Docker

## Contents

- Dockerfile
- zsh config
- vim config
- scripts for service/deps

## Setup

```shell
$ docker build -t columnstore-dev:rockylinux-8 .
$ git clone https://github.com/MariaDB/server.git --recurse-submodules --depth=1
$ docker run --privileged -d --name='csdev' \
    -v path/to/server:/root/server \
    -v ~/.gitconfig:/root/.gitconfig \
    -v ~/.ssh:/root/.ssh \
    columnstore-dev:rockylinux-8 /usr/sbin/init
$ docker exec -it -w /root/server/columnstore/columnstore/build csdev /bin/zsh
$ git checkout develop
$ . /opt/rh/gcc-toolset-12/enable && ./bootstrap_mcs.sh -D -t Debug -d Rocky
```
