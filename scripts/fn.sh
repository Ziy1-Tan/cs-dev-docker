#!/bin/bash

funcname=$1
mcsdir=/root/server/storage/columnstore/columnstore

touch $mcsdir/mysql-test/columnstore/future/func_$funcname.test
touch $mcsdir/utils/funcexp/func_$funcname.cpp
