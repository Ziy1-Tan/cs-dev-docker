#!/bin/sh

mkdir /run/mysqld && chown -R mysql:mysql /run/mysqld
mkdir /run/mariadb && chown -R mysql:mysql /run/mariadb

ExecStartPre=/bin/sh -c "mkdir -p /run/mysqld; chown -R mysql:mysql /run/mysqld; mkdir -p /run/mariadb; chown -R mysql:mysql /run/mariadb"