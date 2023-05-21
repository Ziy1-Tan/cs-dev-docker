# ColumnStore Dev

## Contents

- Dockerfile
- zshrc config
- vim config
- service/deps script

## Dev Setup

```shell
$ docker build -t columnstore .
$ git clone https://github.com/MariaDB/server.git --recurse-submodules --depth=1
$ docker run --privileged -v path/to/server:/root/server -d -v --name='cs-dev' columnstore:latest /usr/sbin/init
$ docker exec -it -w /root/server cs-dev /bin/zsh
$ cd storage/columnstore/columnstore/build && git checkout develop
$ . /opt/rh/gcc-toolset-12/enable && ./bootstrap_mcs.sh -D -t Debug -d Rocky
```
