#!/bin/bash
# 如果CLUSTER_ID变量为空字符串，则为Zookeeper模式搭建集群，否则为KRaft模式搭建集群
if [ -z "$CLUSTER_ID" ]; then
	exec bin/kafka-server-start.sh config/server.properties \
		--override zookeeper.connect=$ZOOKEEPER_URL \
		--override advertised.listeners=PLAINTEXT://$KAFKA_HOST:$KAFKA_PORT \
		--override broker.id=$BROKER_ID \
		--override socket.send.buffer.bytes=$SEND_BUFFER_BYTE \
		--override socket.receive.buffer.bytes=$RECEIVE_BUFFER_BYTE \
		--override socket.request.max.bytes=$REQUEST_MAX_BYTES \
		--override num.partitions=$NUM_PARTITIONS
else
	# 先替换配置文件中变量
	sed -i "/^node.id=/s/.*/node.id=$NODE_ID/" config/kraft/server.properties
	sed -i "/^controller.quorum.voters=/s/.*/controller.quorum.voters=$VOTER_LIST/" config/kraft/server.properties
	sed -i "/^process.roles=/s/.*/process.roles=$PROCESS_ROLE/" config/kraft/server.properties
	sed -i "/^advertised.listeners=/s/.*/advertised.listeners=PLAINTEXT:\/\/$KAFKA_HOST:$KAFKA_PORT/" config/kraft/server.properties
	sed -i "/^socket.send.buffer.bytes=/s/.*/socket.send.buffer.bytes=$SEND_BUFFER_BYTE/" config/kraft/server.properties
	sed -i "/^socket.receive.buffer.bytes=/s/.*/socket.receive.buffer.bytes=$RECEIVE_BUFFER_BYTE/" config/kraft/server.properties
	sed -i "/^socket.request.max.bytes=/s/.*/socket.request.max.bytes=$REQUEST_MAX_BYTES/" config/kraft/server.properties
	sed -i "/^num.partitions=/s/.*/num.partitions=$NUM_PARTITIONS/" config/kraft/server.properties
	# 格式化数据目录
	bin/kafka-storage.sh format -t $CLUSTER_ID -c config/kraft/server.properties
	# 启动Kafka
	exec bin/kafka-server-start.sh config/kraft/server.properties
fi