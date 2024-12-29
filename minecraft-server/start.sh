#!/bin/sh
if [ "$EULA" = "true" ]; then
	echo "By setting the EULA to TRUE, you are indicating your agreement to Minecraft EULA (https://aka.ms/MinecraftEULA)."
	echo "eula=true" >eula.txt
fi
exec java -Xmx${JVM_MAX} -Xms${JVM_MIN} -XX:+UseZGC -jar /minecraft/server.jar nogui
