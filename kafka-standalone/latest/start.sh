#!/bin/bash
# 如果CLUSTER_ID变量为空字符串，则为Zookeeper模式搭建集群，否则为KRaft模式搭建集群
if [ -z "$CLUSTER_ID" ]; then
	echo 以Zookeeper模式运行集群！
	exec bin/kafka-server-start.sh config/server.properties \
		--override zookeeper.connect=$ZOOKEEPER_URL \
		--override advertised.listeners=PLAINTEXT://$KAFKA_HOST:$KAFKA_PORT \
		--override broker.id=$BROKER_ID \
		--override socket.send.buffer.bytes=$SEND_BUFFER_BYTE \
		--override socket.receive.buffer.bytes=$RECEIVE_BUFFER_BYTE \
		--override socket.request.max.bytes=$REQUEST_MAX_BYTES \
		--override num.partitions=$NUM_PARTITIONS
else
	echo 以KRaft模式运行集群！
	# 根据PROCESS_ROLE的不同，执行不同的配置文件
	CONFIG_FILE=config/kraft/server.properties
	if [ "$PROCESS_ROLE" = "broker" ]; then
		echo 当前节点为Broker类型！
		CONFIG_FILE=config/kraft/broker.properties
	elif [ "$PROCESS_ROLE" = "controller" ]; then
		echo 当前节点为Controller类型！
		CONFIG_FILE=config/kraft/controller.properties
	else
		echo 当前节点为混合节点！
	fi
	# 替换配置文件中变量
	sed -i "/^node.id=/s/.*/node.id=$NODE_ID/" $CONFIG_FILE
	sed -i "/^controller.quorum.voters=/s/.*/controller.quorum.voters=$VOTER_LIST/" $CONFIG_FILE
	sed -i "/^advertised.listeners=/s/.*/advertised.listeners=PLAINTEXT:\/\/$KAFKA_HOST:$KAFKA_PORT/" $CONFIG_FILE
	sed -i "/^socket.send.buffer.bytes=/s/.*/socket.send.buffer.bytes=$SEND_BUFFER_BYTE/" $CONFIG_FILE
	sed -i "/^socket.receive.buffer.bytes=/s/.*/socket.receive.buffer.bytes=$RECEIVE_BUFFER_BYTE/" $CONFIG_FILE
	sed -i "/^socket.request.max.bytes=/s/.*/socket.request.max.bytes=$REQUEST_MAX_BYTES/" $CONFIG_FILE
	sed -i "/^num.partitions=/s/.*/num.partitions=$NUM_PARTITIONS/" $CONFIG_FILE
	# 格式化数据目录
	bin/kafka-storage.sh format -t $CLUSTER_ID -c $CONFIG_FILE
	# 启动Kafka
	exec bin/kafka-server-start.sh $CONFIG_FILE
fi