#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2022 Oracle and/or its affiliates. All rights reserved.
# 
# Since: November, 2016
# Author: gerald.venzl@oracle.com
# Description: Creates an Oracle Database based on following parameters:
#              $ORACLE_SID: The Oracle SID and CDB name
#              $ORACLE_PDB: The PDB name
#              $ORACLE_PWD: The Oracle password
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 

set -e

echo "Clean tmp files start"

rm -rfv /var/cache/yum

rm -rfv /var/tmp/yum-*

yum clean all

rm -fv "$INSTALL_FILE_2"

rm -fv "$INSTALL_DIR/$INSTALL_FILE_2"

rm -rfv /tmp/*

rm -rfv /var/cache/*

rm -rfv /var/log/*

rm -rfv /var/logs/*

rm -rfv /var/tmp/*

echo "Clean tmp files done"

exit 0;