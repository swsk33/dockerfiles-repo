FROM azul/zulu-openjdk-alpine:17-jre-headless-latest
RUN mkdir /minecraft \
	&& wget -O /minecraft/server.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
ADD eula.txt /minecraft/
ADD server.properties /minecraft/
ENV LANG C.UTF-8
EXPOSE 25565
VOLUME ["/minecraft"]
WORKDIR /minecraft/
CMD ["java", "-Xmx1024M", "-Xms512M", "-jar", "server.jar", "nogui"]