#!/bin/bash

source /oracle_installation/colorecho.sh

echo_title2 "Execute install.sh file ..."

trap "echo_red '******* ERROR: Something went wrong.'; exit 1" SIGTERM
trap "echo_red '******* Caught SIGINT signal. Stopping...'; exit 2" SIGINT

if [ ! -z $DOWNLOAD_URL ]; then
	cd /u01
	wget $DOWNLOAD_URL
	tar -xvzf database.tar.gz
	chmod -R 777 /u01/database
fi

if [ ! -d "/u01/database" ]; then
	echo_red "Installation files not found. Unzip installation files into mounted(/u01) folder"
	exit 1
fi

echo_command2 "Installing Oracle Database 11g"

/u01/database/runInstaller -silent -ignorePrereq -waitforcompletion -responseFile /oracle_installation/db_install.rsp | while read line; do echo_command2 "runInstaller: $line"; done
sudo /u01/app/oraInventory/orainstRoot.sh | while read line; do echo_command2 "orainstRoot.sh: $line"; done
sudo /u01/app/oracle/product/11.2.0/dbhome_1/root.sh | while read line; do echo_command2 "root.sh: $line"; done