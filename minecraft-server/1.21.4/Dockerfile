FROM bellsoft/liberica-runtime-container:jre-21-slim-glibc
ADD https://piston-data.mojang.com/v1/objects/4707d00eb834b446575d89a61a11b5d548d8c001/server.jar /minecraft/server.jar
ADD eula.txt /minecraft/data/
ADD server.properties /minecraft/data/
ADD start.sh /
RUN chmod +x /start.sh
# 端口
EXPOSE 25565
# 环境变量
ENV LANG=C.UTF-8
ENV JVM_MIN=256M
ENV JVM_MAX=512M
VOLUME ["/minecraft/data"]
WORKDIR /minecraft/data
CMD ["/start.sh"]