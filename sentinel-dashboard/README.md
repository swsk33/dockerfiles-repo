# Alibaba流量防卫兵面板

一个Alibaba Sentinel Dashboard镜像，用于快速在服务器上部署一个流量防卫兵面板实例。

- [官方文档](https://sentinelguard.io/zh-cn/docs/introduction.html)
- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/sentinel-dashboard/latest/Dockerfile)

# 说明

## 1，创建并运行容器

使用以下命令创建容器：

```bash
docker run -id --name=sentinel -p 8849:8849 -p 8719:8719 swsk33/sentinel-dashboard
```

此时服务端已经启动，访问`服务器地址:8849`即可，加入到微服务配置也是这个地址。

面板的默认用户名和密码都是`sentinel`，如果说自定义用户名和密码，那么在创建容器时指定`USER`和`PASSWORD`环境变量：

```bash
docker run -id --name=sentinel -p 8849:8849 -p 8719:8719 \
	-e USER=admin -e PASSWORD=123456 \
	swsk33/sentinel-dashboard
```

这样，就指定了用户名为`admin`，密码为`123456`。

## 2，其余环境变量配置

本Docker镜像仅仅包含了下列两个环境变量：

- `USER` 控制台用户名
- `PASSWORD` 控制台密码

其余可配置项也可以通过**环境变量**配置，可以参考官方文档中**控制台配置项**部分：[传送门](https://sentinelguard.io/zh-cn/docs/dashboard.html)

比如需要配置配置项`auth.enabled`为`false`，那么就需要设定环境变量`auth_enabled=false`，命令如下：

```bash
docker run -id --name=sentinel -p 8849:8849 -p 8719:8719 \
	-e auth_enabled=false \
	swsk33/sentinel-dashboard
```

这是因为**通过环境变量进行配置**时，环境变量名是不支持`.`的，所以需要将对应配置项名称中`.`其更换为`_`符号。