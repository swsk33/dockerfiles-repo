FROM azul/zulu-openjdk-alpine:17-jre-headless-latest
RUN apk add --no-cache bash \
	&& mkdir /kafka \
	&& wget -O /kafka.tgz https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz \
	&& tar -xzvf kafka.tgz -C ./kafka/ --strip-components 1 \
	&& rm -rf kafka.tgz /var/cache/apk/*
EXPOSE 9092
ENV LANG=C.UTF-8
ENV ZOOKEEPER_HOST=127.0.0.1
ENV ZOOKEEPER_PORT=2181
ENV KAFKA_HOST=127.0.0.1
VOLUME ["/kafka/config"]
WORKDIR /kafka
CMD bin/kafka-server-start.sh config/server.properties --override zookeeper.connect=$ZOOKEEPER_HOST:$ZOOKEEPER_PORT --override advertised.listeners=PLAINTEXT://$KAFKA_HOST:9092