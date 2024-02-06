## Nacos单机服务端镜像

这是一个Alibaba Nacos单机镜像，用于快速在服务器上部署一个单机Nacos实例。

- [官方文档](https://nacos.io/docs/latest/quickstart/quick-start/)
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

如果需要配置数据库等等，则需要修改配置文件，参考[官网](https://nacos.io/docs/latest/guide/admin/deployment/)修改配置。

## 4，常见问题

### (1) 使用MySQL作为数据源无法启动

对于使用MySQL数据源，如果配置了数据库但是仍然连不上，无法启动成功，可以将数据库地址配置`db.url.0`后面参数部分先全部去掉（`?`后面部分），然后仅加上参数`serverTimezone=GMT%2B8`，最终如下：

```properties
db.url.0=jdbc:mysql://地址:3306/nacos?serverTimezone=GMT%2B8
```

### (2) 开启鉴权

自`2.2.2`版本开始，在未开启鉴权时，**默认控制台将不需要登录即可访问**，同时在控制台中给予提示，提醒用户当前集群未开启鉴权。因此如需开启鉴权，请按照下列方式修改配置文件。

首先找到`nacos.core.auth.enabled`配置项，将其值修改为`true`以**开启鉴权**：

```properties
nacos.core.auth.enabled=true
```

然后找到`nacos.core.auth.plugin.nacos.token.secret.key`配置项配置一个自定义的**Token密钥**，建议为Base64编码字符串，且**原始密钥长度不得低于32字符**，可以到[Base64编码工具](https://c.runoob.com/front-end/693/)中，将一个不低于32长度的自定义字符串（作为你的密钥）加密为Base64，然后粘贴至该配置项，例如：

```properties
nacos.core.auth.plugin.nacos.token.secret.key=YWJjZGVmZ2hpamtsbW5vcGFiY2RlZmdoaWprbG1ub3A=
```

最后找到`nacos.core.auth.server.identity.key`和`nacos.core.auth.server.identity.value`这两个配置项，它们分别表示**服务身份识别的`key`和`value`**，自拟一个值即可，例如：

```properties
nacos.core.auth.server.identity.key=my-key
nacos.core.auth.server.identity.value=my-value
```

需要注意的是，如果搭建集群，需要保证同一集群中每个Nacos节点的下列配置的值**完全一致**：

- `nacos.core.auth.plugin.nacos.token.secret.key`
- `nacos.core.auth.server.identity.key`
- `nacos.core.auth.server.identity.value`

修改完成配置后记得重启容器！