#!/bin/bash

# Launch, utilizing the SIGTERM/SIGINT propagation pattern from 
# http://veithen.github.io/2014/11/16/sigterm-propagation.html
: ${PARAMS:=""}
if [ ! -f /root/.dogecoin/blocks/blk00000.dat ]; then
    echo "Downloading dogecoin bootstrap..."
    wget -O /root/.dogecoin/dogecoin-bootstrap.tar.gz https://dogeparty.net/bootstrap/dogecoin-bootstrap.tar.gz
	echo "Extracting dogecoin bootstrap..."
    pv /root/.dogecoin/dogecoin-bootstrap.tar.gz | tar -xz -C /root/.dogecoin/
	echo "Deleting dogecoin bootstrap tar gz..."
    rm /root/.dogecoin/dogecoin-bootstrap.tar.gz
	rm /root/.dogecoin/checksums.txt
fi

trap 'kill -TERM $PID' TERM INT
/usr/local/bin/dogecoind ${PARAMS} $@ &
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?
