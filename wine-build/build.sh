#!/bin/bash
# 构建脚本
VERSION=$1
if [ ! $VERSION ]; then
	echo 请指定版本号！
else
	IMAGE=swsk33/wine-build
	echo 正在构建...
	docker build -f ./$VERSION/Dockerfile -t $IMAGE:$VERSION ./$VERSION
	echo 创建latest Tag...
	docker tag $IMAGE:$VERSION $IMAGE
	echo 构建完成！
fi
