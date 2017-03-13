#!/bin/bash

source /oracle_installation/colorecho.sh
/solutions/install_packages.sh

echo_title "Execute oracle.sh file ..."

if [ ! -d "/u01/app/oracle/product/11.2.0/dbhome_1" ]; then
	
	echo_command "Database is not installed. Installing..."
	mkdir -p -m 777 /u01/app/oracle
	mkdir -p -m 777 /u01/app/oraInventory
	mkdir -p -m 777 /u01/app/oracle/dpdump
	chown -R oracle:oinstall /u01
	echo_command "--> /oracle_installation/install.sh"
	/oracle_installation/install.sh
fi

if [ ! -d "/u01/initial" ]; then
	mkdir -p -m 777 /u01/initial
	cp /oracle_installation/start_databases.sh /u01/initial
	cp /oracle_installation/create_databases.sh /u01/initial
fi

echo_command "Checking shared memory..."
df -h | grep "Mounted on" && df -h | egrep --color "^.*/u01" || echo_command "Shared memory is not mounted."
chmod 777 /u01/app/oracle/dpdump

#Start listener
echo_command "--> /oracle_installation/start_listener.sh"
/oracle_installation/start_listener.sh

#Create databases
echo_command "--> /u01/initial/create_databases.sh"
/u01/initial/create_databases.sh

#Start databases
echo_command "--> /u01/initial/start_databases.sh"
/u01/initial/start_databases.sh

#Listener log
echo_command "--> /oracle_installation/listener_log.sh"
/oracle_installation/listener_log.sh