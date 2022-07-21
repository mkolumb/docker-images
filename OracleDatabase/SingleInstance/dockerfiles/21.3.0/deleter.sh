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

echo "Clean obsolete - '$1'"

rm -rf $ORACLE_HOME

$INSTALL_DIR/$CLEANER_FILE

echo "Yum remove - '$1'"

yum clean all

rpm --rebuilddb

package-cleanup --problems

yum -y -q erase $PACKAGE_NAME > /dev/null

echo "Download - '$1'"

wget -q $INSTALL_FILE_1

echo "Install '$INSTALL_FILE_2' - '$1'"

unbuffer yum -y localinstall $INSTALL_FILE_2

echo "Clean yum after - '$1'"

$INSTALL_DIR/$CLEANER_FILE

echo "Clean files - '$1'"

if [ "$1" -lt "24" ]; then 
	echo "delete file: '$REMOVE_FILE_1'"
	rm -rfv $REMOVE_FILE_1
fi

if [ "$1" -lt "23" ]; then 
	echo "delete file: '$REMOVE_FILE_2'"
	rm -rfv $REMOVE_FILE_2
fi

if [ "$1" -lt "22" ]; then 
	echo "delete file: '$REMOVE_FILE_3'"
	rm -rfv $REMOVE_FILE_3
fi

if [ "$1" -lt "21" ]; then 
	echo "delete file: '$REMOVE_FILE_4'"
	rm -rfv $REMOVE_FILE_4
fi

if [ "$1" -lt "20" ]; then 
	echo "delete dir: '$REMOVE_DIR_1'"
	rm -rf $REMOVE_DIR_1
fi

if [ "$1" -lt "19" ]; then 
	echo "delete dir: '$REMOVE_DIR_2'"
	rm -rf $REMOVE_DIR_2
fi

if [ "$1" -lt "18" ]; then 
	echo "delete dir: '$REMOVE_DIR_3'"
	rm -rf $REMOVE_DIR_3
fi

if [ "$1" -lt "17" ]; then 
	echo "delete dir: '$REMOVE_DIR_4'"
	rm -rf $REMOVE_DIR_4
fi

if [ "$1" -lt "16" ]; then 
	echo "delete dir: '$REMOVE_DIR_5'"
	rm -rf $REMOVE_DIR_5
fi

if [ "$1" -lt "15" ]; then 
	echo "delete dir: '$REMOVE_DIR_6'"
	rm -rf $REMOVE_DIR_6
fi

if [ "$1" -lt "14" ]; then 
	echo "delete dir: '$REMOVE_DIR_7'"
	rm -rf $REMOVE_DIR_7
fi

if [ "$1" -lt "13" ]; then 
	echo "delete dir: '$REMOVE_DIR_8'"
	rm -rf $REMOVE_DIR_8
fi

if [ "$1" -lt "12" ]; then 
	echo "delete dir: '$REMOVE_DIR_9'"
	rm -rf $REMOVE_DIR_9
fi

if [ "$1" -lt "11" ]; then 
	echo "delete dir: '$REMOVE_DIR_10'"
	rm -rf $REMOVE_DIR_10
fi

if [ "$1" -lt "10" ]; then 
	echo "delete dir: '$REMOVE_DIR_11'"
	rm -rf $REMOVE_DIR_11
fi

if [ "$1" -lt "9" ]; then 
	echo "delete dir: '$REMOVE_DIR_12'"
	rm -rf $REMOVE_DIR_12
fi

if [ "$1" -lt "8" ]; then 
	echo "delete dir: '$REMOVE_DIR_13'"
	rm -rf $REMOVE_DIR_13
fi

if [ "$1" -lt "7" ]; then 
	echo "delete dir: '$REMOVE_DIR_14'"
	rm -rf $REMOVE_DIR_14
fi

if [ "$1" -lt "6" ]; then 
	echo "delete dir: '$REMOVE_DIR_15'"
	rm -rf $REMOVE_DIR_15
fi

if [ "$1" -lt "5" ]; then 
	echo "delete dir: '$REMOVE_DIR_16'"
	rm -rf $REMOVE_DIR_16
fi

if [ "$1" -lt "4" ]; then 
	echo "delete dir: '$REMOVE_DIR_17'"
	rm -rf $REMOVE_DIR_17
fi

if [ "$1" -lt "3" ]; then 
	echo "delete dir: '$REMOVE_DIR_18'"
	rm -rf $REMOVE_DIR_18
fi

if [ "$1" -lt "2" ]; then 
	echo "delete dir: '$REMOVE_DIR_19'"
	rm -rf $REMOVE_DIR_19
fi

if [ "$1" -lt "1" ]; then 
	echo "delete dir: '$REMOVE_DIR_20'"
	rm -rf $REMOVE_DIR_20
fi

$INSTALL_DIR/$CLEANER_FILE

exit 0;