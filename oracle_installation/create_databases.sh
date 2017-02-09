#!/bin/bash

source /oracle_installation/colorecho.sh

trap_db() {
	trap "echo_red 'Caught SIGTERM signal, shutting down...'; stop" SIGTERM;
	trap "echo_red 'Caught SIGINT signal, shutting down...'; stop" SIGINT;
}

create_db() {
	echo_command "Database does not exist. Creating database..."
	dbca -silent -createDatabase -responseFile /u01/initial/dbca_$1.rsp | while read line; do echo_command "dbca: $line"; done
	echo_command "Database created $1."
	touch /u01/app/oracle/product/11.2.0/dbhome_1/dbs/init$1.ora
	trap_db
}

stop() {
    trap '' SIGINT SIGTERM
	shu_immediate
	echo_command3 "Shutting down listener..."
	lsnrctl stop | while read line; do echo_command3 "lsnrctl: $line"; done
	kill $LISTENER_PID
	exit 0
}

shu_immediate() {
	ps -ef | grep ora_pmon | grep -v grep > /dev/null && \
	echo_command3 "Shutting down the database..." && \
	sqlplus SYS/SYS as sysdba <<-EOF |
		set echo on
		shutdown immediate;
		exit 0
	EOF
	while read line; do echo_command3 "sqlplus: $line"; done
}
