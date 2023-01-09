# Alibaba流量防卫兵面板

一个Alibaba Sentinel Dashboard镜像，用于快速在服务器上部署一个流量防卫兵面板实例。

- [官方文档](https://sentinelguard.io/zh-cn/docs/introduction.html)
- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/sentinel-dashboard/latest/Dockerfile)

# 说明

## 创建并运行容器

使用以下命令创建容器：

```bash
docker run -id --name=sentinel -p 8849:8849 -p 8719:8719 swsk33/sentinel-dashboard
```

此时服务端已经启动，访问`服务器地址:8849`即可，加入到微服务配置也是这个地址。

面板的默认用户名和密码都是`sentinel`，如果说自定义用户名和密码，那么在创建容器时指定`USER`和`PASSWORD`环境变量：

```bash
docker run -id --name=sentinel -p 8849:8849 -p 8719:8719 -e USER=admin -e PASSWORD=123456 swsk33/sentinel-dashboard
```

这样，就指定了用户名为`admin`，密码为`123456`。