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

########### Move DB files ############
function moveFiles {

   if [ ! -d "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID" ]; then
      mkdir -p "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   fi;

   mv "$ORACLE_BASE_CONFIG"/dbs/spfile"$ORACLE_SID".ora "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   mv "$ORACLE_BASE_CONFIG"/dbs/orapw"$ORACLE_SID" "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   mv "$ORACLE_BASE_HOME"/network/admin/sqlnet.ora "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   mv "$ORACLE_BASE_HOME"/network/admin/listener.ora "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   mv "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   if [ -a "$ORACLE_HOME"/install/.docker_* ]; then
      mv "$ORACLE_HOME"/install/.docker_* "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   fi;

   # oracle user does not have permissions in /etc, hence cp and not mv
   cp /etc/oratab "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/
   
   symLinkFiles;
}

########### Symbolic link DB files ############
function symLinkFiles {

   if [ ! -L "$ORACLE_BASE_CONFIG"/dbs/spfile"$ORACLE_SID".ora ]; then
      ln -s "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/spfile"$ORACLE_SID".ora "$ORACLE_BASE_CONFIG"/dbs/spfile"$ORACLE_SID".ora
   fi;
   
   if [ ! -L "$ORACLE_BASE_CONFIG"/dbs/orapw"$ORACLE_SID" ]; then
      ln -s "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/orapw"$ORACLE_SID" "$ORACLE_BASE_CONFIG"/dbs/orapw"$ORACLE_SID"
   fi;
   
   if [ ! -L "$ORACLE_BASE_HOME"/network/admin/sqlnet.ora ]; then
      ln -s "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/sqlnet.ora "$ORACLE_BASE_HOME"/network/admin/sqlnet.ora
   fi;

   if [ ! -L "$ORACLE_BASE_HOME"/network/admin/listener.ora ]; then
      ln -s "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/listener.ora "$ORACLE_BASE_HOME"/network/admin/listener.ora
   fi;

   if [ ! -L "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora ]; then
      ln -s "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/tnsnames.ora "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora
   fi;

   # oracle user does not have permissions in /etc, hence cp and not ln 
   cp "$ORACLE_BASE"/oradata/dbconfig/"$ORACLE_SID"/oratab /etc/oratab

}

########### Undoing the symbolic links ############
function undoSymLinkFiles {

   if [ -L $ORACLE_BASE_CONFIG/dbs/spfile$ORACLE_SID.ora ]; then
      rm $ORACLE_BASE_CONFIG/dbs/spfile$ORACLE_SID.ora
   fi;

   if [ -L $ORACLE_BASE_CONFIG/dbs/orapw$ORACLE_SID ]; then
      rm $ORACLE_BASE_CONFIG/dbs/orapw$ORACLE_SID
   fi;

   if [ -L $ORACLE_BASE_HOME/network/admin/sqlnet.ora ]; then
      rm $ORACLE_BASE_HOME/network/admin/sqlnet.ora
   fi;

   if [ -L $ORACLE_BASE_HOME/network/admin/listener.ora ]; then
      rm $ORACLE_BASE_HOME/network/admin/listener.ora
   fi;

   if [ -L $ORACLE_BASE_HOME/network/admin/tnsnames.ora ]; then
      rm $ORACLE_BASE_HOME/network/admin/tnsnames.ora
   fi;

}

########### SIGINT handler ############
function _int() {
   echo "Stopping container."
   echo "SIGINT received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF
   lsnrctl stop
}

########### SIGTERM handler ############
function _term() {
   echo "Stopping container."
   echo "SIGTERM received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF
   lsnrctl stop
}

# Read-only Oracle Home Config
ORACLE_BASE_CONFIG=$("$ORACLE_HOME"/bin/orabaseconfig)
export ORACLE_BASE_CONFIG

# Default for ORACLE PDB
export ORACLE_PDB=${ORACLE_PDB:-ORCLPDB1}

# Make ORACLE_PDB upper case
# Github issue # 984
export ORACLE_PDB=${ORACLE_PDB^^}

# Default for ORACLE CHARACTERSET
export ORACLE_CHARACTERSET=${ORACLE_CHARACTERSET:-AL32UTF8}

###################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
############# MAIN ################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
###################################

# Create database
"$ORACLE_BASE"/"$CREATE_DB_FILE_2" $ORACLE_SID "$ORACLE_PDB" "$ORACLE_PWD" || exit 1;

exit 0;