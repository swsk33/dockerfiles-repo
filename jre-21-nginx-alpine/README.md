# 集成Nginx的Java运行环境镜像

集成了Nginx的Java 21运行环境镜像，基于Zulu OpenJDK，Alpine操作系统。

- [官方Azul Zulu安装指引](https://docs.azul.com/core/zulu-openjdk/install/alpine-linux)
- [官方Nginx安装指引](https://nginx.org/en/linux_packages.html#Alpine)
- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/jre-21-nginx-alpine/latest/Dockerfile)

# 说明

可以以该容器为基础镜像制作部署自己的Java单体应用程序。

制作完成后，使用容器之前最好是先创建两个具名数据卷用于持久化Nginx的**配置**和**日志**：

```bash
docker volume create nginx-config
docker volume create nginx-log
```

上述数据卷对应容器内位置：

- `nginx-config`：`/etc/nginx`
- `nginx-log`：`/var/log/nginx`

最新版即`latest`镜像中的JRE和Nginx是最新的，其余镜像Tag为`JRE版本号-Nginx版本号`格式。