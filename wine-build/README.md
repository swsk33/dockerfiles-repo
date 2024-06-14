# Wine构建环境

该容器为基于Debian 12镜像制作的Wine构建环境，可以在该环境中完成Wine源码的构建。

- [官方文档](https://wiki.winehq.org/Building_Wine)
- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/wine-build)

# 说明

## 1，创建容器

使用以下命令创建容器：

```bash
docker run -id --name=wine-build \
	-v wine-build:/wine \
	swsk33/wine-build
```

## 2，下载或拷贝源码

将Wine源码解压至数据卷`wine-build`对应的目录下，它对应容器中的`/wine`目录，然后进入容器：

```bash
docker exec -it wine-build bash
```

即可开始进行构建。

## 3，构建说明

除了参考上述官方文档之外，还可以参考文章：[传送门](https://juejin.cn/post/6989168468700430350#heading-8)

由于容器中已经安装好了编译所需的依赖，因此无需在执行文章中安装依赖操作。

进入源码目录时，记得先赋予`configure`脚本可执行权限：

```bash
chmod +x ./configure
```

## 4，版本号说明

镜像`tag`版本号对应的是需要构建的Wine版本号！例如：

- `6.0`表示适用于构建所有Wine 6.x版本的环境
- `7.0-9.0` 表示适用于构建所有Wine 7.x到9.x这个范围内版本的环境