# Spring Boot测试程序

用于测试的SpringBoot接口的程序，可以测试网络、转发等等。

- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/springboot-test/latest/Dockerfile)

# 说明

## 1，创建并运行容器

使用以下命令创建容器：

```bash
docker run -id --name=springboot-test -p 8800:8800 swsk33/springboot-test
```

此时容器已经启动，访问`服务器地址:8800`即可得到一个消息。

## 2，用途

这是一个简单的测试网络用的容器，没有任何实质性功能用途。

主要是做以下**测试或者学习**：

- **测试端口映射**：容器内使用`8800`端口，可以映射到宿主机不同端口进行测试
- **测试Docker内网**：比如说可以使用一个Nginx容器反向代理至这个SpringBoot测试容器以测试内网的反向代理
- ...