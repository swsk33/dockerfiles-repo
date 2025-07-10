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

# 加载构建函数
source ../sh-build-utils

# 指定相关额外构建参数
declare -A build_arg_map
build_arg_map["build_java_version"]="$java_version"
build_arg_map["gdal_version"]="$gdal_version"

# 执行构建
build_docker_image "$image_name" "$image_version" Dockerfile latest build_arg_map
