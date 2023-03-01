FROM azul/zulu-openjdk-alpine:17-jre-headless-latest
ADD start.sh /kafka/
RUN apk add --no-cache bash \
	&& wget -O /kafka.tgz https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz \
	&& chmod +x /kafka/start.sh \
	&& tar -xzvf kafka.tgz -C ./kafka/ --strip-components 1 \
	&& rm -rf kafka.tgz /var/cache/apk/*
EXPOSE 9092
ENV LANG=C.UTF-8
VOLUME ["/kafka/config"]
WORKDIR /kafka
CMD ["./start.sh"]