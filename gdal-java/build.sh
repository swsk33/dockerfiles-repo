#!/bin/bash

# 处理参数
# GDAL版本
gdal_version=$1
# Java版本
java_version=$2

# 打印帮助信息
function print_help {
	echo 使用方法：
	echo ./build.sh GDAL版本 Java版本
}

# 检查参数
if [ -z "$gdal_version" ]; then
	echo 请指定GDAL版本！
	print_help
	exit
fi

if [ -z "$java_version" ]; then
	echo 请指定Java版本！，例如：\"8\"、\"17.0.15\"等
	print_help
	exit
fi

# 镜像信息
image_version=${gdal_version}-${java_version}
image_name=swsk33/gdal-java
echo 正在构建...

# 检查代理
if [ -z "${http_proxy}" -o -z "${https_proxy}" ]; then
	docker build \
		--build-arg build_java_version=${java_version} \
		-f ./latest/Dockerfile -t $image_name:$image_version ./latest/
else
	echo 将使用代理构建...
	docker build \
		--network host \
		--build-arg build_java_version=${java_version} \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		-f ./latest/Dockerfile -t $image_name:$image_version ./latest/
fi

echo 创建latest Tag...
docker tag $image_name:$image_version $image_name
echo 构建完成！
