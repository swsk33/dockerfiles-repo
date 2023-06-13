#!/bin/bash
# 构建脚本
VERSION=$1
if [ ! $VERSION ]; then
	echo 请指定版本号！
else
	echo 正在构建...
	docker build -f ./latest/Dockerfile -t swsk33/kafka-standalone:$VERSION --network host --build-arg ALL_PROXY="http://127.0.0.1:7500" ./latest
	echo 创建latest Tag...
	docker tag swsk33/kafka-standalone:$VERSION swsk33/kafka-standalone
	echo 构建完成！
fi