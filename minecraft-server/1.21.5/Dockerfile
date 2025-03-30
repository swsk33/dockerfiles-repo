FROM bellsoft/liberica-runtime-container:jre-21-slim-glibc
WORKDIR /minecraft/data
ADD https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar /minecraft/server.jar
ADD start.sh /
ADD timezone.tar /usr/share/zoneinfo/
RUN chmod +x /start.sh \
	&& mkdir -p /minecraft/data \
	&& java -jar /minecraft/server.jar --initSettings
# 端口
EXPOSE 25565
# 环境变量
ENV LANG=C.UTF-8
ENV JVM_MIN=256M
ENV JVM_MAX=512M
ENV TZ="Asia/Shanghai"
ENV EULA=false
# 数据卷
VOLUME ["/minecraft/data"]
CMD ["/start.sh"]