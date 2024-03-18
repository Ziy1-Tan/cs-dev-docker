Dev Container for MariaDB ColumnStore

# Contents

1. Dockerfile
2. Vim config
3. Scripts for service & dependencies

# Quick Start

```shell
# 1. Clone the repository
git clone https://github.com/MariaDB/server.git
cd server
git submodule update --init --recursive --depth=1

# 2. Replace the forked repository
cd server/storage/columnstore/columnstore
git remote remove origin
git remote add origin <URL-TO-YOUR-FORK>
git checkout develop
git config --global --add safe.directory `pwd`

# 3. Build in the container
docker build -t columnstore-dev:rockylinux-8 .
docker run --privileged -d --name='cs-dev' -v path/to/server:/root/server columnstore-dev:rockylinux-8 /usr/sbin/init
docker exec -it -w /root/server/storage/columnstore/columnstore/build cs-dev /bin/bash
. /opt/rh/gcc-toolset-12/enable && ./bootstrap_mcs.sh
```

# Note

`Could not open mysql.plugin table: "Table 'mysql.plugin' doesn't exist". Some plugins may be not loaded`

- Reinstall mysql data

```shell
rm -rf /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user=mysql
```

`Plugin 'gssapi' registration as a AUTHENTICATION failed.`

- Remove unused plugins

```shell
rm -rf /etc/my.cnf.d/auth_gssapi.cnf
rm -rf /etc/my.cnf.d/provider_*
```

`/usr/sbin/mariadbd: Error while setting value 'ONplugin-load-add=ha_columnstore.so' to 'columnstore-use-import-for-batchinsert'`

- Overwrite the config file

```shell
echo -e '[mysqld]\nplugin-load-add=ha_columnstore.so\ncolumnstore_use_import_for_batchinsert = ON\n\ncollation_server = utf8_general_ci\ncharacter_set_server = utf8' > /etc/my.cnf.d/columnstore.cnf
```
