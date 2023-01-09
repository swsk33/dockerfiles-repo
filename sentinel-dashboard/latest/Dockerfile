FROM azul/zulu-openjdk-alpine:17-jre
ADD sentinel-dashboard.jar /sentinel/
EXPOSE 8849
EXPOSE 8719
WORKDIR /sentinel/
ENV USER sentinel
ENV PASSWORD sentinel
CMD java -Dserver.port=8849 -Dsentinel.dashboard.auth.username=$USER -Dsentinel.dashboard.auth.password=$PASSWORD -jar --add-exports=java.base/sun.net.util=ALL-UNNAMED sentinel-dashboard.jar