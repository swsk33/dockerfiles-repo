# Kafka单机镜像

这是一个Kafka的单机镜像，可用于快速地部署一个单机Kafka实例，`Tag`的命名规则为：`Scala版本-Kafka版本`。

- Kafka官方文档：[传送门](https://kafka.apache.org/documentation/)
- Dockerfile文件：[传送门](https://github.com/swsk33/dockerfiles-repo/blob/master/kafka-standalone/latest/Dockerfile)

# 说明

## 1，创建`Zookeeper`容器

由于`Kafka`依赖于`Zookeeper`，所以首先要拉取并创建`Zookeeper`容器：

```bash
docker pull zookeeper
docker run -id --name=zookeeper -v zookeeper-data:/data -v zookeeper-datalog:/datalog -v zookeeper-log:/logs zookeeper
```

## 2，创建并运行`Kafka`容器

使用以下命令创建容器：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config -e ZOOKEEPER_HOST=zookeeper --link=zookeeper -e KAFKA_HOST=部署Kafka的服务器的外网地址 swsk33/kafka-standalone
```

可见创建`kafka`容器时，链接到了开始创建的`zookeeper`容器并指定了环境变量参数。如果你的`Zookeeper`容器名为自定义的，那么`--link`参数和`ZOOKEEPER_HOST`变量也需要注意相应地做出改变。

上述`KAFKA_HOST`必须要配置为部署`Kafka`的服务器的**外网地址**，否则会导致Java中生产者集成`Kafka`时无法连接。

所有的环境变量参数如下：

- `ZOOKEEPER_HOST` 指定`Kafka`要使用的`Zookeeper`的地址，默认是`127.0.0.1`
- `ZOOKEEPER_PORT` 指定`Kafka`要使用的`Zookeeper`的端口，默认是`2181`
- `KAFKA_HOST` 指定`Kafka`所在服务器的外网地址，必须要配置

若你的`Zookeeper`部署在别处或者是端口不为默认，可通过这两个环境变量参数指定。

## 3，修改配置文件

根据上述配置之后，配置文件数据卷位于`/var/lib/docker/volumes/kafka-config/_data`目录下，可以按需修改其中的配置文件，然后重启容器即可。

配置文件官方文档：[传送门](https://kafka.apache.org/documentation/#configuration)

## 4，常用命令

上述创建的容器名为`kafka`，若你的容器名不是这个，请在下列命令中把`kafka`替换成自己的容器名。

### (1) 日志查看

查看`Kafka`实时日志：

```bash
docker logs -f kafka
```

### (2) 管理`Topic`（主题）

创建`Topic`：

```bash
docker exec -it kafka bin/kafka-topics.sh --create --topic Topic名 --bootstrap-server localhost:9092
```

查看`Topic`详细信息：

```bash
docker exec -it kafka bin/kafka-topics.sh --describe --topic Topic名 --bootstrap-server localhost:9092
```

列出所有`Topic`：

```bash
docker exec -it kafka bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```

删除`Topic`：

```bash
docker exec -it kafka bin/kafka-topics.sh --delete --topic Topic名 --bootstrap-server localhost:9092
```

查看所有`Topic`管理命令帮助：

```bash
docker exec -it kafka bin/kafka-topics.sh
```

请把上述命令中的`Topic名`替换为自己自定义的主题名字。