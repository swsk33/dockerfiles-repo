#!/bin/bash
# 构建脚本
VERSION=$1
if [ ! $VERSION ]; then
	echo 请指定版本号！
else
	IMAGE=swsk33/gdal-java
	echo 正在构建...
	docker build \
		--network host \
		--build-arg http_proxy=http://127.0.0.1:7500 \
		--build-arg https_proxy=http://127.0.0.1:7500 \
		-f ./latest/Dockerfile -t $IMAGE:$VERSION ./latest/
	echo 创建latest Tag...
	docker tag $IMAGE:$VERSION $IMAGE
	echo 构建完成！
fi
