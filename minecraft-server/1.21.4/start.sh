#!/bin/sh
exec java -Xmx${JVM_MAX} -Xms${JVM_MIN} -jar /minecraft/server.jar nogui
