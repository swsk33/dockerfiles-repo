FROM bellsoft/liberica-runtime-container:jre-21-slim-glibc
WORKDIR /minecraft/data
ADD https://meta.fabricmc.net/v2/versions/loader/1.21.4/0.16.9/1.0.1/server/jar /minecraft/fabric-server.jar
ADD start.sh /
ADD timezone.tar /usr/share/zoneinfo/
RUN chmod +x /start.sh \
	&& mkdir -p /minecraft/data \
	&& java -jar /minecraft/fabric-server.jar --initSettings \
	&& rm -r /minecraft/data/logs/
# 端口
EXPOSE 25565
# 环境变量
ENV LANG=C.UTF-8
ENV JVM_MIN=512M
ENV JVM_MAX=1G
ENV TZ="Asia/Shanghai"
ENV EULA=false
# 数据卷
VOLUME ["/minecraft/data"]
CMD ["/start.sh"]