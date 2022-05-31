#!/bin/sh

case $1 in
    s|start)
        echo "Starting..."
        systemctl start mariadb-columnstore.service
        systemctl start mariadb.service
        echo "Start finished..."
        ;;
    p|stop)
        echo "Stopping..."
        systemctl stop mariadb-columnstore.service
        systemctl stop mariadb.service
        echo "Stop finished..."
        ;;
    r|restart)
        echo "Restarting..."
        systemctl restart mariadb-columnstore.service
        systemctl restart mariadb.service
        echo "Restarting finished..."
        ;;
    *)
        echo "Usage $0 start|stop|restart"
        ;;
esac

exit 0