#!/bin/bash

source /oracle_installation/colorecho.sh

trap_db() {
	trap "echo_red 'Caught SIGTERM signal, shutting down...'; stop" SIGTERM;
	trap "echo_red 'Caught SIGINT signal, shutting down...'; stop" SIGINT;
}

start_listener() {
	echo_command2 "Starting listener..."
	lsnrctl start | while read line; do echo_command2 "start_listener: $line"; done
	LISTENER_PID=$!
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
	sqlplus / as sysdba <<-EOF |
		set echo on
		shutdown immediate;
		exit 0
	EOF
	while read line; do echo_command3 "sqlplus: $line"; done
}

start_listener