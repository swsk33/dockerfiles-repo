# GDAL Java环境

一个包含了GDAL及其Java绑定的容器环境，支持直接部署调用GDAL的Java程序并运行，无需手动配置绑定与动态链接库等。

- [GDAL官方文档](https://gdal.org/en/stable/index.html)
- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/gdal-java/latest/Dockerfile)

镜像Tag格式：`GDAL版本号-Java版本号`

# 说明

该镜像已包含下列环境可直接使用：

- GDAL工具和动态链接库、JNI绑定
- Java运行环境

此外，容器已配置好`LD_LIBRARY_PATH`、`GDAL_DATA`、`JAVA_TOOL_OPTIONS`环境变量，将调用GDAL的Java程序放到容器中时可直接使用`java -jar`命令运行，**无需**配置上述环境变量以及`java.library.path`属性。