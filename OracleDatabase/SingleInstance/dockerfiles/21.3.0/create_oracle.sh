#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2022 Oracle and/or its affiliates. All rights reserved.
#
# Since: November, 2016
# Author: gerald.venzl@oracle.com
# Description: Runs the Oracle Database inside the container
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
#

sqlplus / as sysdba <<EOF
ALTER DATABASE DATAFILE '/opt/oracle/oradata/XE/system01.dbf' RESIZE 1390000000;

ALTER DATABASE DATAFILE '/opt/oracle/oradata/XE/sysaux01.dbf' RESIZE 580000000;

ALTER DATABASE DATAFILE '/opt/oracle/oradata/XE/undotbs01.dbf' RESIZE 123000000;

ALTER DATABASE DATAFILE '/opt/oracle/oradata/XE/users01.dbf' RESIZE 2900000;

alter database add logfile ('/opt/oracle/oradata/XE/redo21.log') size 4m;

alter database add logfile ('/opt/oracle/oradata/XE/redo22.log') size 4m;

alter database add logfile ('/opt/oracle/oradata/XE/redo23.log') size 4m;

alter system switch logfile;

alter system checkpoint;

alter database drop logfile group 1;

alter database drop logfile group 2;

alter database drop logfile group 3;

exit;
EOF

rm -rfv /opt/oracle/oradata/XE/redo0*

cd /tmp

rm -rfv *
