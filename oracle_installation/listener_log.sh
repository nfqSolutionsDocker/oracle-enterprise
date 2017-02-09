#!/bin/bash

source /oracle_installation/colorecho.sh

echo_title "Execute listener_log.sh file ..."

tail -F -n 0 /u01/app/oracle/diag/tnslsnr/$HOSTNAME/listener/trace/listener.log | while read line; do echo_command "listener: $line"; done &
LISTENER_PID=$!

wait $LISTENER_PID