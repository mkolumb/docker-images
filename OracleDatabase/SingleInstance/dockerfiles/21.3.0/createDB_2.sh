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

############## Setting up network related config files (sqlnet.ora, listener.ora) ##############
function setupNetworkConfig {
  mkdir -p "$ORACLE_BASE_HOME"/network/admin

  # sqlnet.ora
  echo "NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT, HOSTNAME)" > "$ORACLE_BASE_HOME"/network/admin/sqlnet.ora

  # listener.ora
  echo "LISTENER = 
(DESCRIPTION_LIST = 
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521)) 
  ) 
) 

DEDICATED_THROUGH_BROKER_LISTENER=ON
DIAG_ADR_ENABLED = off
" > "$ORACLE_BASE_HOME"/network/admin/listener.ora

}

function setupTnsnames {
  mkdir -p "$ORACLE_BASE_HOME"/network/admin

  # tnsnames.ora
  echo "$ORACLE_SID=localhost:1521/$ORACLE_SID" > "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora
  echo "$ORACLE_PDB= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = $ORACLE_PDB)
  )
)" >> "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora

}

function setupNetworkConfigXE {
  # sqlnet.ora
  echo "NAMES.DIRECTORY_PATH= (TNSNAMES, EZCONNECT, HOSTNAME)" > "$ORACLE_BASE_HOME"/network/admin/sqlnet.ora

  # listener.ora 
   echo "# listener.ora Network Configuration File:
         
SID_LIST_LISTENER = 
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = PLSExtProc)
      (ORACLE_HOME = $ORACLE_HOME)
      (PROGRAM = extproc)
    )
  )

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_XE))
      (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
    )
  )

DEFAULT_SERVICE_LISTENER = (XE)" > "$ORACLE_BASE_HOME"/network/admin/listener.ora

# TNS Names.ora
   echo "# tnsnames.ora Network Configuration File:

XE =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XE)
    )
  )

LISTENER_XE =
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))

XEPDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XEPDB1)
    )
  )

EXTPROC_CONNECTION_DATA =
  (DESCRIPTION =
     (ADDRESS_LIST =
       (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_XE))
     )
     (CONNECT_DATA =
       (SID = PLSExtProc)
       (PRESENTATION = RO)
     )
  )
" > "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora
}

function dbSetupSQL {
  # Remove second control file, fix local_listener, make PDB auto open, enable EM global port
  # Create externally mapped oracle user for health check
  sqlplus / as sysdba << EOF
ALTER SYSTEM SET control_files='$ORACLE_BASE/oradata/$ORACLE_SID/control01.ctl' scope=spfile;
ALTER SYSTEM SET local_listener='';
ALTER PLUGGABLE DATABASE $ORACLE_PDB SAVE STATE;
EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED (TRUE);

ALTER SESSION SET "_oracle_script" = true;
CREATE USER OPS\$oracle IDENTIFIED EXTERNALLY;
GRANT CREATE SESSION TO OPS\$oracle;
GRANT SELECT ON sys.v_\$pdbs TO OPS\$oracle;
GRANT SELECT ON sys.v_\$database TO OPS\$oracle;
ALTER USER OPS\$oracle SET container_data=all for sys.v_\$pdbs container = current;

exit;
EOF

}

###################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
############# MAIN ################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
###################################

# Creating database for XE edition
if [ "${ORACLE_SID}" = "XE" ]; then

# Setting up network config for XE database
setupNetworkConfigXE;

exit 0
fi;
