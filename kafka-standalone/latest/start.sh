#!/bin/bash
cd /kafka
nohup bin/zookeeper-server-start.sh config/zookeeper.properties > zookeeper.log 2>&1 &
bin/kafka-server-start.sh config/server.properties