#!/bin/bash
# 构建脚本
VERSION=$1
if [ ! $VERSION ]; then
	echo 请指定版本号！
else
	IMAGE=swsk33/minecraft-server
	echo 正在构建...
	docker build -f ./$VERSION/Dockerfile -t $IMAGE:$VERSION --network host --build-arg ALL_PROXY="http://127.0.0.1:7500" .
	echo 创建latest Tag...
	docker tag $IMAGE:$VERSION $IMAGE
	echo 构建完成！
fi
