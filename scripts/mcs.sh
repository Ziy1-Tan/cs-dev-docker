#!/bin/sh

color_normal=$(tput sgr0)
color_bold=$(tput bold)
color_red="$color_bold$(tput setaf 1)"
color_green="$color_bold$(tput setaf 2)"

check_service() {
    if systemctl is-active --quiet $1; then
        echo "$1 service $color_green OK $color_normal"
    else
        echo "$1 service $color_red failed $color_normal"
        service $1 status
    fi
}

case $1 in
s | start)
    mkdir -p /run/mysqld &&
        chown -R mysql:mysql /run/mysqld &&
        mkdir -p /run/mariadb &&
        chown -R mysql:mysql /run/mariadb
    echo "Starting..."
    systemctl start mariadb-columnstore.service
    check_service mariadb-columnstore
    systemctl start mariadb.service
    check_service mariadb
    echo "Start finished..."
    ;;
p | stop)
    echo "Stopping..."
    systemctl stop mariadb-columnstore.service
    systemctl stop mariadb.service
    echo "Stop finished..."
    ;;
r | restart)
    echo "Restarting..."
    systemctl restart mariadb-columnstore.service
    check_service mariadb-columnstore
    systemctl restart mariadb.service
    check_service mariadb
    echo "Restarting finished..."
    ;;
*)
    echo "Usage $0 start|stop|restart"
    ;;
esac

exit 0
