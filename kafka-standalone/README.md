# Kafka镜像

这是一个Kafka的Docker镜像，可用于快速地部署一个单机Kafka实例，并且也支持集群配置，`Tag`的命名规则为：`Scala版本-Kafka版本`。

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

### (1) 单机部署

使用以下命令创建容器：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config \
-e ZOOKEEPER_URL=zookeeper:2181 \
-e KAFKA_HOST=部署Kafka的服务器的外网地址 \
--link=zookeeper swsk33/kafka-standalone
```

可见创建`kafka`容器时，链接到了开始创建的`zookeeper`容器并指定了环境变量参数。如果你的`Zookeeper`容器名为自定义的，那么`--link`参数和`ZOOKEEPER_HOST`变量也需要注意相应地做出改变。

上述`KAFKA_HOST`必须要配置为部署`Kafka`的服务器的**外网地址**，否则会导致Java中生产者集成`Kafka`时无法连接。

上述环境变量参数如下：

- `ZOOKEEPER_URL` 指定`Kafka`要使用的`Zookeeper`的地址和端口，默认是`127.0.0.1:2181`
- `KAFKA_HOST` 指定`Kafka`所在服务器的外网地址，必须要配置

建议在给环境变量指定值时，将环境变量值用英文双引号`"`包围。

若你的`Zookeeper`部署在别处，需要将`ZOOKEEPER_URL`变量值改为实际的服务器地址和端口，若你的`Zookeeper`为集群形式，也可以在此指定多个`Zookeeper`地址，每个地址用英文逗号`,`隔开，例如：

```bash
-e ZOOKEEPER_URL="zookeeper0:2181,zookeeper1:2181,zookeeper2:2181"
```

### (2) 集群部署

该镜像支持集群部署，多个`Kafka`节点通过在同一个`ZooKeeper`（或同一个`Zookeeper`集群）上注册，就形成了一个集群。

在多个要部署`Kafka`节点的服务器上执行下列命令：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config \
-e ZOOKEEPER_URL=zookeeper地址和端口 \
-e KAFKA_HOST=部署Kafka的服务器的外网地址 \
-e BROKER_ID=brokerId \
-e NUM_PARTITIONS=Topic分区数 \
--link=zookeeper swsk33/kafka-standalone
```

除了之前的一些必要配置之外，这里还需要注意：

- `BROKER_ID` 表示每个`Kafka`节点的`id`，同一个集群中，每个节点的`id`不能重复！`id`为一个整数例如`0`，`1`等等
- `NUM_PARTITIONS` 指定每个主题的分区数，最好和集群中节点数保持一致

### (3) 全部环境变量配置项

这里列出所有的可以通过指定环境变量来完成配置的配置项：

|      环境变量名       |                  配置意义                   |      默认值      |
| :-------------------: | :-----------------------------------------: | :--------------: |
|    `ZOOKEEPER_URL`    |    `Kafka`所使用的Zookeeper的地址和端口     | `127.0.0.1:2181` |
|     `KAFKA_HOST`      |        `Kafka`所在的服务器的外网地址        |   `127.0.0.1`    |
|      `BROKER_ID`      | `Kafka`节点`id`，用于区分同一集群中不同节点 |       `0`        |
|  `SEND_BUFFER_BYTE`   |  每次发送的数据包的最大大小（单位：字节）   |     `102400`     |
| `RECEIVE_BUFFER_BYTE` |  每次接收的数据包的最大大小（单位：字节）   |     `102400`     |
|  `REQUEST_MAX_BYTES`  |      接收的最大请求大小（单位：字节）       |   `104857600`    |
|   `NUM_PARTITIONS`    |           每个`Topic`的默认分区数           |       `1`        |

如果不需要改变某个配置的值，就不需要在容器创建时指定这个环境变量，其它配置可以通过修改配置文件的方式完成，修改配置文件的方式见下一节。

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