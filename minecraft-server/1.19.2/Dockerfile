FROM bellsoft/liberica-runtime-container:jre-21-slim-glibc
ADD https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar /minecraft/server.jar
ADD 1.19.2/server.properties /minecraft/data/
ADD eula.txt /minecraft/data/
ADD start.sh /
ADD timezone.tar /usr/share/zoneinfo/
RUN chmod +x /start.sh \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 端口
EXPOSE 25565
# 环境变量
ENV LANG=C.UTF-8
ENV JVM_MIN=256M
ENV JVM_MAX=512M
ENV TZ="Asia/Shanghai"
VOLUME ["/minecraft/data"]
WORKDIR /minecraft/data
CMD ["/start.sh"]