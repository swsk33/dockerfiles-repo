#!/bin/bash
cd /shardingsphere-proxy/bin
./start.sh $PORT
tail -f /shardingsphere-proxy/logs/stdout.log
