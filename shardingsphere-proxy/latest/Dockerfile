FROM azul/zulu-openjdk-alpine:21-jre-headless-latest
ADD start.sh /
RUN apk add --no-cache bash \
	&& mkdir /shardingsphere-proxy \
	&& wget -O /proxy.tar.gz https://dlcdn.apache.org/shardingsphere/5.4.1/apache-shardingsphere-5.4.1-shardingsphere-proxy-bin.tar.gz \
	&& tar -xzvf proxy.tar.gz -C ./shardingsphere-proxy/ --strip-components 1 \
	&& chmod +x /start.sh \
	&& chmod +x /shardingsphere-proxy/bin/start.sh \
	&& mkdir -p /shardingsphere-proxy/ext-lib \
	&& wget -O /shardingsphere-proxy/ext-lib/mysql-connector-j-8.2.0.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.2.0/mysql-connector-j-8.2.0.jar \
	&& rm -rf proxy.tar.gz /var/cache/apk/*
EXPOSE 3307
# 环境变量
ENV LANG=C.UTF-8
ENV PORT=3307
# 数据卷
VOLUME ["/shardingsphere-proxy/logs", "/shardingsphere-proxy/conf", "/shardingsphere-proxy/ext-lib"]
# 启动
WORKDIR /shardingsphere-proxy
CMD ["/start.sh"]