#!/bin/bash

source /oracle_installation/colorecho.sh

export ORACLE_SID=$1

sqlplus SYS/SYS as sysdba <<-EOF | 
	shutdown immediate;
	startup mount exclusive restrict;
	exit 0;
EOF
while read line; do echo_red "sqlplus: $line"; done

rman target / <<-EOF |
	drop database including backups noprompt;
	exit 0;
EOF
while read line; do echo_red "rman: $line"; done

sed '/'$ORACLE_SID'/d' /etc/oratab
rm /u01/initial/spfile_$ORACLE_SID.ora
rm /u01/initial/dbca_$ORACLE_SID.rsp
rm /u01/initial/startup_$ORACLE_SID.sh
sed '/'$ORACLE_SID'/d' /u01/initial/create_databases.sh
sed '/'$ORACLE_SID'/d' /u01/initial/start_databases.sh
rm $ORACLE_HOME/dbs/lk$ORACLE_SID
rm $ORACLE_HOME/dbs/orapw$ORACLE_SID
rm $ORACLE_HOME/dbs/init$ORACLE_SID.ora
rm $ORACLE_HOME/dbs/hc_$ORACLE_SID.dat
rm -rf /u01/app/oracle/admin/$ORACLE_SID
rm -rf /u01/app/oracle/oradata/$ORACLE_SID