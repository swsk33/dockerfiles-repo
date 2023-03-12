## Nacos单机服务端镜像

这是一个Alibaba Nacos单机镜像，用于快速在服务器上部署一个单机Nacos实例。

- [官方文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)
- [Dockerfile文件](https://github.com/swsk33/dockerfiles-repo/blob/master/nacos-standalone/Dockerfile)

## 说明

## 1，拉取镜像并创建数据卷

拉取镜像之后，需要创建具名数据卷以存放Nacos配置文件：

```bash
docker volume create nacos-config
```

## 2，创建并启动容器

```bash
docker run -id --name=nacos -p 8848:8848 -p 9848:9848 -v nacos-config:/nacos/conf swsk33/nacos-standalone
```

## 3，修改配置文件

根据上述配置之后，配置文件位于`/var/lib/docker/volumes/nacos-config/_data`目录下，如果只是简单使用无需修改配置。

如果需要配置数据库等等，则需要修改配置文件，参考[官网](https://nacos.io/zh-cn/docs/deployment.html)修改配置。

## 4，常见问题

### (1) 使用MySQL作为数据源无法启动

对于使用MySQL数据源，如果配置了数据库但是仍然连不上，无法启动成功，可以将数据库地址配置`db.url.0`后面参数部分先全部去掉（`?`后面部分），然后仅加上参数`serverTimezone=GMT%2B8`，最终如下：

```properties
db.url.0=jdbc:mysql://地址:3306/nacos?serverTimezone=GMT%2B8
```

### (2) `2.2.0.1`版本启动失败

新的`2.2.0.1`版本需要手动添加一个Base64加密后的密钥配置，否则无法启动。详情见[官方文档说明](https://nacos.io/zh-cn/docs/v2/guide/user/auth.html)。

自定义的密钥需要为**Base64编码**的字符串，且**原始密钥长度不得低于32字符**。

先到[Base64编码工具](https://c.runoob.com/front-end/693/)中，将一个不低于32长度的自定义字符串（作为你的密钥）加密为Base64，然后找到配置文件中`nacos.core.auth.plugin.nacos.token.secret.key`这个配置项，粘贴即可。

修改完成配置后记得重启容器！