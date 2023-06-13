FROM azul/zulu-openjdk-debian:17-jre-headless-latest
ADD start.sh /nacos/
RUN apt update \
	&& apt install -y --no-install-recommends wget ca-certificates \
	&& wget -O nacos.tar.gz https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz \
	&& tar -xzvf nacos.tar.gz \
	&& chmod +x /nacos/start.sh \
	&& apt purge -y wget ca-certificates \
	&& apt autoremove -y \
	&& apt clean \
	&& rm -rf nacos.tar.gz /var/lib/apt/lists/*
ENV LANG C.UTF-8
VOLUME ["/nacos/conf"]
EXPOSE 8848
EXPOSE 9848
WORKDIR /nacos
CMD ["bash", "./start.sh"]