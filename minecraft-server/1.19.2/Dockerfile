FROM bellsoft/liberica-runtime-container:jre-21-slim-glibc
ADD start.sh /
ADD eula.txt /minecraft/data/
ADD server.properties /minecraft/data/
ADD https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar /minecraft/server.jar
RUN chmod +x /start.sh
# 环境变量
ENV LANG=C.UTF-8
ENV JVM_MIN=256M
ENV JVM_MAX=512M
EXPOSE 25565
VOLUME ["/minecraft/data"]
WORKDIR /minecraft/data
CMD ["/start.sh"]