FROM azul/zulu-openjdk-alpine:17-jre-headless-latest
ADD start.sh /
RUN apk add --no-cache bash \
	&& mkdir /kafka \
	&& wget -O /kafka.tgz https://downloads.apache.org/kafka/3.4.1/kafka_2.13-3.4.1.tgz \
	&& tar -xzvf kafka.tgz -C ./kafka/ --strip-components 1 \
	&& chmod +x /start.sh \
	&& rm -rf kafka.tgz /var/cache/apk/*
EXPOSE 9092
EXPOSE 9093
# 环境变量
# 语言
ENV LANG=C.UTF-8
# 参数配置
# Zookeeper模式集群参数
ENV ZOOKEEPER_URL=127.0.0.1:2181
ENV BROKER_ID=0
# KRaft模式集群参数
ENV CLUSTER_ID=""
ENV NODE_ID=1
ENV VOTER_LIST=1@127.0.0.1:9093
ENV PROCESS_ROLE=broker,controller
# 通用参数
ENV KAFKA_HOST=127.0.0.1
ENV KAFKA_PORT=9092
ENV SEND_BUFFER_BYTE=102400
ENV RECEIVE_BUFFER_BYTE=102400
ENV REQUEST_MAX_BYTES=104857600
ENV NUM_PARTITIONS=1
VOLUME ["/kafka/config", "/tmp/kafka-logs", "/tmp/kraft-combined-logs"]
WORKDIR /kafka
CMD ["/start.sh"]