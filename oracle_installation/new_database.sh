#!/bin/bash

source /oracle_installation/colorecho.sh

echo_title "Execute new_database.sh file ..."

export DATABASE=$1
alert_log=/u01/app/oracle/diag/rdbms/$(echo $DATABASE | tr [:upper:] [:lower:])/$DATABASE/trace/alert_$DATABASE.log

echo_command "create dbca.rsp file: /u01/initial/dbca_$DATABASE.rsp"
echo "[GENERAL]" >> /u01/initial/dbca_$DATABASE.rsp
echo "RESPONSEFILE_VERSION = \"11.2.0\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "OPERATION_TYPE = \"createDatabase\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[CREATEDATABASE]" >> /u01/initial/dbca_$DATABASE.rsp
echo "GDBNAME = \"$DATABASE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "SID = \"$DATABASE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "TEMPLATENAME = \"General_Purpose.dbc\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "SYSPASSWORD = \"SYS\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "SYSTEMPASSWORD = \"SYS\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "DATAFILEDESTINATION=/u01/app/oracle/oradata" >> /u01/initial/dbca_$DATABASE.rsp
echo "RECOVERYAREADESTINATION=/u01/app/oracle/oradata" >> /u01/initial/dbca_$DATABASE.rsp
echo "STORAGETYPE=FS" >> /u01/initial/dbca_$DATABASE.rsp
echo "CHARACTERSET=\"AL32UTF8\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "INITPARAMS=\"memory_target=0,sga_target=500,pga_aggregate_target=100\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[createTemplateFromDB]" >> /u01/initial/dbca_$DATABASE.rsp
echo "SOURCEDB = \"myhost:1521:$DATABASE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "SYSDBAUSERNAME = \"system\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "TEMPLATENAME = \"My Copy TEMPLATE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[createCloneTemplate]" >> /u01/initial/dbca_$DATABASE.rsp
echo "SOURCEDB = \"$DATABASE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "TEMPLATENAME = \"My Clone TEMPLATE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[DELETEDATABASE]" >> /u01/initial/dbca_$DATABASE.rsp
echo "SOURCEDB = \"$DATABASE\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[generateScripts]" >> /u01/initial/dbca_$DATABASE.rsp
echo "TEMPLATENAME = \"New Database\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "GDBNAME = \"orcl11.us.oracle.com\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[CONFIGUREDATABASE]" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[ADDINSTANCE]" >> /u01/initial/dbca_$DATABASE.rsp
echo "DB_UNIQUE_NAME = \"orcl11c.us.oracle.com\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "NODELIST=" >> /u01/initial/dbca_$DATABASE.rsp
echo "SYSDBAUSERNAME = \"sys\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "" >> /u01/initial/dbca_$DATABASE.rsp
echo "[DELETEINSTANCE]" >> /u01/initial/dbca_$DATABASE.rsp
echo "DB_UNIQUE_NAME = \"orcl11c.us.oracle.com\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "INSTANCENAME = \"orcl11g\"" >> /u01/initial/dbca_$DATABASE.rsp
echo "SYSDBAUSERNAME = \"sys\"" >> /u01/initial/dbca_$DATABASE.rsp

echo_command "create spfile.ora file: /u01/initial/spfile_$DATABASE.ora"
echo "$DATABASE.__db_cache_size=356515840" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__java_pool_size=4194304" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__large_pool_size=4194304" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__pga_aggregate_target=104857600" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__sga_target=524288000" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__shared_io_pool_size=0" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__shared_pool_size=150994944" >> /u01/initial/spfile_$DATABASE.ora
echo "$DATABASE.__streams_pool_size=0" >> /u01/initial/spfile_$DATABASE.ora
echo "*.audit_file_dest='/u01/app/oracle/admin/$DATABASE/adump'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.audit_trail='db'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.compatible='11.2.0.0.0'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.control_files='/u01/app/oracle/oradata/$DATABASE/control01.ctl','/u01/app/oracle/flash_recovery_area/$DATABASE/control02.ctl'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.db_block_size=8192" >> /u01/initial/spfile_$DATABASE.ora
echo "*.db_domain=''" >> /u01/initial/spfile_$DATABASE.ora
echo "*.db_name='$(echo $DATABASE | cut -c -8)'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.db_recovery_file_dest='/u01/app/oracle/flash_recovery_area'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.db_recovery_file_dest_size=4070572032" >> /u01/initial/spfile_$DATABASE.ora
echo "*.db_unique_name='$DATABASE'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.diagnostic_dest='/u01/app/oracle'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.dispatchers='(PROTOCOL=TCP) (SERVICE="$DATABASE"XDB)'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.memory_target=0" >> /u01/initial/spfile_$DATABASE.ora
echo "*.open_cursors=300" >> /u01/initial/spfile_$DATABASE.ora
echo "*.pga_aggregate_target=104857600" >> /u01/initial/spfile_$DATABASE.ora
echo "*.processes=150" >> /u01/initial/spfile_$DATABASE.ora
echo "*.remote_login_passwordfile='EXCLUSIVE'" >> /u01/initial/spfile_$DATABASE.ora
echo "*.sga_target=524288000" >> /u01/initial/spfile_$DATABASE.ora
echo "*.undo_tablespace='UNDOTBS1'" >> /u01/initial/spfile_$DATABASE.ora

echo_command "Checking shared memory..."
df -h | grep "Mounted on" && df -h | egrep --color "^.*/dev/shm" || echo_command "Shared memory is not mounted."

echo "if [ ! -f /u01/app/oracle/product/11.2.0/dbhome_1/dbs/init$DATABASE.ora ]; then" >> /u01/initial/create_databases.sh
echo "  create_db $DATABASE;" >> /u01/initial/create_databases.sh
echo "fi " >> /u01/initial/create_databases.sh

echo "/u01/initial/startup_$DATABASE.sh" >> /u01/initial/start_databases.sh

echo_command "create startup.sh file: /u01/initial/startup_"$DATABASE".sh"
echo "#!/usr/bin/env bash" >> /u01/initial/startup_$DATABASE.sh
echo "" >> /u01/initial/startup_$DATABASE.sh
echo "set -e" >> /u01/initial/startup_$DATABASE.sh
echo "source /oracle_installation/colorecho.sh" >> /u01/initial/startup_$DATABASE.sh
echo "" >> /u01/initial/startup_$DATABASE.sh
echo "echo_command \"Starting database...\"" >> /u01/initial/startup_$DATABASE.sh
echo "tail -F -n 0 \$alert_log | while read line; do echo_command \"alertlog: \$line\"; done &" >> /u01/initial/startup_$DATABASE.sh
echo "export ORACLE_SID=$DATABASE" >> /u01/initial/startup_$DATABASE.sh
echo "sqlplus / as sysdba <<-EOF | " >> /u01/initial/startup_$DATABASE.sh
echo "STARTUP pfile=/u01/initial/spfile_$DATABASE.ora" >> /u01/initial/startup_$DATABASE.sh
echo "EOF" >> /u01/initial/startup_$DATABASE.sh
echo "while read line; do echo_command \"sqlplus: \$line\"; done" >> /u01/initial/startup_$DATABASE.sh

echo_command "added startup.sh file to entrypoint_oracle.sh"
chmod 777 /u01/initial/startup_$DATABASE.sh
chmod a+x /u01/initial/startup_$DATABASE.sh
sed -i -e 's/\r$//' /u01/initial/startup_$DATABASE.sh

/u01/initial/create_databases.sh
/u01/initial/startup_$DATABASE.sh