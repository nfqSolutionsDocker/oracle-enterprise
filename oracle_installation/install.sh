#!/bin/bash

source /oracle_installation/colorecho.sh

echo_title "Execute install.sh file ..."

trap "echo_red '******* ERROR: Something went wrong.'; exit 1" SIGTERM
trap "echo_red '******* Caught SIGINT signal. Stopping...'; exit 2" SIGINT

if [ ! -z "$DOWNLOAD_URL" ]; then
	cd /u01
	echo_command "Descargando fichero database.tar.gz ..."
	wget $DOWNLOAD_URL > /dev/null
	echo_command "Descomprimiendo fichero database.tar.gz ..."
	tar -xvzf database.tar.gz > /dev/null
	chmod -R 777 /u01/database
fi

if [ ! -d "/u01/database" ]; then
	echo_red "Installation files not found. Unzip installation files into mounted(/u01) folder"
	exit 1
fi

echo_command "Installing Oracle Database 11g"

/u01/database/runInstaller -silent -ignorePrereq -waitforcompletion -responseFile /oracle_installation/db_install.rsp | while read line; do echo_command "runInstaller: $line"; done
sudo /u01/app/oraInventory/orainstRoot.sh | while read line; do echo_command "orainstRoot.sh: $line"; done
sudo /u01/app/oracle/product/11.2.0/dbhome_1/root.sh | while read line; do echo_command "root.sh: $line"; done