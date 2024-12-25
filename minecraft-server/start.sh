#!/bin/sh
exec java -Xmx${JVM_MAX} -Xms${JVM_MIN} -XX:+UseZGC -jar /minecraft/server.jar nogui
