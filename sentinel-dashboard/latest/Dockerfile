FROM azul/zulu-openjdk-alpine:21-jre-headless-latest
RUN mkdir /sentinel \
	&& wget -O /sentinel/sentinel-dashboard.jar https://github.com/alibaba/Sentinel/releases/download/1.8.8/sentinel-dashboard-1.8.8.jar
EXPOSE 8849
EXPOSE 8719
WORKDIR /sentinel/
ENV USER sentinel
ENV PASSWORD sentinel
CMD exec java -Dserver.port=8849 -Dsentinel.dashboard.auth.username=$USER -Dsentinel.dashboard.auth.password=$PASSWORD -jar --add-exports=java.base/sun.net.util=ALL-UNNAMED sentinel-dashboard.jar