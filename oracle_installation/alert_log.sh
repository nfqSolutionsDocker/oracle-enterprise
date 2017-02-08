#!/bin/bash

source /oracle_installation/colorecho.sh

tail -F -n 0 /u01/app/oracle/diag/tnslsnr/$HOSTNAME/listener/trace/listener.log | while read line; do echo_command3 "start_listener: $line"; done &
LISTENER_PID=$!

wait $LISTENER_PID