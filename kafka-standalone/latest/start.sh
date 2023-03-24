#!/bin/bash
exec bin/kafka-server-start.sh config/server.properties \
	--override zookeeper.connect=$ZOOKEEPER_URL \
	--override advertised.listeners=PLAINTEXT://$KAFKA_HOST:9092 \
	--override broker.id=$BROKER_ID \
	--override socket.send.buffer.bytes=$SEND_BUFFER_BYTE \
	--override socket.receive.buffer.bytes=$RECEIVE_BUFFER_BYTE \
	--override socket.request.max.bytes=$REQUEST_MAX_BYTES \
	--override num.partitions=$NUM_PARTITIONS