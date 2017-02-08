#!/bin/bash

source /oracle_installation/colorecho.sh
/solutions/install_packages.sh

echo_title "Execute entrypoint.sh file ..."

if [ ! -d "/u01/oracle/app/product/11.2.0/dbhome_1" ]; then
	
	echo_command "Database is not installed. Installing..."
	sudo mkdir -p -m 777 /u01
	sudo mkdir -p -m 777 /u01/oracle
	sudo mkdir -p -m 777 /u01/oracle/app
	sudo mkdir -p -m 777 /u01/oracle/oraInventory
	sudo mkdir -p -m 777 /u01/oracle/dpdump
	sudo chown -R solutions:oinstall /u01
	echo_command "--> /oracle_installation/install.sh"
	/oracle_installation/install.sh
fi

if [ ! -d "/u01/initial" ]; then
	sudo mkdir -p -m 777 /u01/initial
	sudo cp /oracle_installation/start_databases.sh /u01/initial
	sudo cp /oracle_installation/create_databases.sh /u01/initial
fi

echo_command "Checking shared memory..."
df -h | grep "Mounted on" && df -h | egrep --color "^.*/u01" || echo "Shared memory is not mounted."
chmod 777 /u01/oracle/dpdump

#Start listener
/oracle_installation/start_listener.sh

#Create databases
/u01/initial/create_databases.sh

#Start databases
/u01/initial/start_databases.sh

#Listener log
/oracle_installation/listener_log.sh