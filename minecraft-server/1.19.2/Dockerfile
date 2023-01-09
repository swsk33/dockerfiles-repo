FROM azul/zulu-openjdk-alpine:17-jre
ADD server.jar /minecraft/
ADD eula.txt /minecraft/
ADD server.properties /minecraft/
ENV LANG C.UTF-8
EXPOSE 25565
VOLUME ["/minecraft"]
WORKDIR /minecraft/
CMD ["java", "-Xmx1024M", "-Xms512M", "-jar", "server.jar", "nogui"]