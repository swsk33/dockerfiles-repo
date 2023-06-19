FROM azul/zulu-openjdk-alpine:17-jre-headless-latest
ADD start.sh /
RUN mkdir -p /minecraft/data \
	&& wget -O /minecraft/server.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar \
	&& chmod +x /start.sh
ADD eula.txt /minecraft/data/
ADD server.properties /minecraft/data/
ENV LANG C.UTF-8
EXPOSE 25565
VOLUME ["/minecraft/data"]
WORKDIR /minecraft/data
CMD ["/start.sh"]