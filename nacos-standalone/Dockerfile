FROM azul/zulu-openjdk-debian:17-jre
ADD nacos.tar.gz /
ADD start.sh /nacos/
RUN chmod +x /nacos/start.sh
ENV LANG C.UTF-8
VOLUME ["/nacos/conf"]
EXPOSE 8848
WORKDIR /nacos
CMD ["bash", "./start.sh"]