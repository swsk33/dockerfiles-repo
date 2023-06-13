# Kafka镜像

这是一个Kafka的Docker镜像，可用于快速地部署一个单机Kafka实例，并且也支持集群配置，`Tag`的命名规则为：`Scala版本-Kafka版本`。

- Kafka官方文档：[传送门](https://kafka.apache.org/documentation/)
- Dockerfile文件：[传送门](https://github.com/swsk33/dockerfiles-repo/blob/master/kafka-standalone/latest/Dockerfile)

# 说明

该镜像支持Zookeeper模式和KRaft模式的单机/集群搭建，下面将分别进行介绍，大家选择其一即可。

## 1，Zookeeper模式

### (1) 创建`Zookeeper`容器

在Zookeeper模式下，`Kafka`依赖于`Zookeeper`，所以首先要拉取并创建`Zookeeper`容器：

```bash
docker pull zookeeper
docker run -id --name=zookeeper -v zookeeper-data:/data -v zookeeper-datalog:/datalog -v zookeeper-log:/logs zookeeper
```

### (2) 创建并运行`Kafka`容器

#### 1. 单机部署

使用以下命令创建容器：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e ZOOKEEPER_URL=zookeeper:2181 \
-e KAFKA_HOST=部署Kafka的服务器的外网地址 \
-e KAFKA_PORT=外部访问Kafka容器的端口 \
--link=zookeeper swsk33/kafka-standalone
```

可见创建`kafka`容器时，链接到了开始创建的`zookeeper`容器并指定了环境变量参数。如果你的`Zookeeper`容器名为自定义的，那么`--link`参数和`ZOOKEEPER_HOST`变量也需要注意相应地做出改变。

上述`KAFKA_HOST`必须要配置为部署`Kafka`的服务器的**外网地址**，否则会导致Java中生产者集成`Kafka`时无法连接。

上述环境变量参数如下：

- `ZOOKEEPER_URL` 指定`Kafka`要使用的`Zookeeper`的地址和端口，默认是`127.0.0.1:2181`
- `KAFKA_HOST` 指定`Kafka`所在服务器的外网地址，必须要配置，默认是`127.0.0.1`
- `KAFKA_PORT` 指定外部（通过宿主机）访问这个`Kafka`容器的端口，必须要配置，**该配置值需要和这个容器映射至宿主机上的端口一致**，例如创建这个`Kafka`容器时，将这个容器的`Kafka`端口`9092`映射至了宿主机上的`10000`端口（使用了`-p 10000:9092`参数），那么这个环境变量就要配置为`10000`，默认为`9092`

建议在给环境变量指定值时，将环境变量值用英文双引号`"`包围。

若你的`Zookeeper`部署在别处，需要将`ZOOKEEPER_URL`变量值改为实际的服务器地址和端口，若你的`Zookeeper`为集群形式，也可以在此指定多个`Zookeeper`地址，每个地址用英文逗号`,`隔开，例如：

```bash
-e ZOOKEEPER_URL="zookeeper0:2181,zookeeper1:2181,zookeeper2:2181"
```

#### 2. 集群部署

该镜像支持集群部署，多个`Kafka`节点通过在同一个`ZooKeeper`（或同一个`Zookeeper`集群）上注册，就形成了一个集群。

在**多个**要部署`Kafka`节点的服务器上执行下列命令：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e ZOOKEEPER_URL=zookeeper地址和端口 \
-e KAFKA_HOST=部署Kafka的服务器的外网地址 \
-e KAFKA_PORT=外部访问Kafka容器的端口 \
-e BROKER_ID=brokerId \
-e NUM_PARTITIONS=Topic分区数 \
swsk33/kafka-standalone
```

除了之前的一些必要配置之外，这里还需要注意：

- `BROKER_ID` 表示每个`Kafka`节点的`id`，同一个集群中，每个节点的`id`不能重复！`id`为一个整数例如`0`，`1`等等
- `NUM_PARTITIONS` 指定每个主题的分区数，最好和集群中节点数保持一致，这个参数是**可选的**

## 2，KRaft模式

KRaft模式无需Zookeeper，仅需运行`Kafka`节点即可构成集群。在KRaft模式的集群中，节点类型分为下面三类：

- Broker节点
- Controller节点
- 混合节点

可以通过传递环境变量参数`PROCESS_ROLE`设定该节点的类型，若不传递该环境变量则默认为混合节点，如果对节点类型不太清楚，可以参考[这篇文章](https://juejin.cn/post/7243725952790020133)。

### (1) 设定一个集群`id`

首先自定义一个`16`位长度的**只能是纯英文和数字组成**的字符串，例如`abcdefghijklmnop`，然后将这个字符串通过Base64编码，**编码后得到的结果就作为整个集群的`id`**，现在先将这个`id`记下以备用，可以使用这个[在线工具](https://c.runoob.com/front-end/693/)进行Base64编码。

### (2) 创建并运行`Kafka`容器

#### 1. 单机部署

执行下列命令启动：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e CLUSTER_ID=上述得到的集群id \
-e KAFKA_HOST=部署Kafka的服务器的外网地址 \
-e KAFKA_PORT=外部访问Kafka容器的端口 \
swsk33/kafka-standalone
```

这里`KAFKA_HOST`和`KAFKA_PORT`参数和上述Zookeeper模式中的是一模一样的，具体说明可以参考上述Zookeeper模式中单机部署部分的参数说明。

#### 2. 集群部署

同样地，在KRaft模式下，在多个不同服务器上面运行Kafka容器并配置同一个集群`id`，这些Kafka容器就构成了一个集群。

在**多台**需要部署Kafka容器的服务器上执行命令：

```bash
# 部署Broker节点
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e PROCESS_ROLE=broker \
-e CLUSTER_ID=上述得到的集群id \
-e NODE_ID=这个节点id \
-e KAFKA_HOST=这个Kafka的服务器的外网地址 \
-e KAFKA_PORT=外部访问这个Kafka容器的端口 \
-e VOTER_LIST=集群中全部Controller或者混合节点列表（投票者列表） \
swsk33/kafka-standalone

# 部署Controller节点
docker run -id --name=kafka -p 9093:9093 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e PROCESS_ROLE=controller \
-e CLUSTER_ID=上述得到的集群id \
-e NODE_ID=这个节点id \
-e VOTER_LIST=集群中全部Controller或者混合节点列表（投票者列表） \
swsk33/kafka-standalone

# 部署混合节点
docker run -id --name=kafka -p 9092:9092 -p 9093:9093 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e CLUSTER_ID=上述得到的集群id \
-e NODE_ID=这个节点id \
-e KAFKA_HOST=这个Kafka的服务器的外网地址 \
-e KAFKA_PORT=外部访问这个Kafka容器的端口 \
-e VOTER_LIST=集群中全部Controller或者混合节点列表（投票者列表） \
swsk33/kafka-standalone
```

可见这里涉及到了两个端口`9092`和`9093`，它们的作用如下：

- `9092`端口：用于客户端（生产者或者消费者）投递消息至Kafka消息队列或者从中取出消息，通常Java集成Kafka客户端时访问该端口，下文称之为**客户端通信端口**
- `9093`端口：KRaft模式下节点直接投票选举通信或者是从Controller节点获取元数据的端口，由于KRaft模式下没有了Zookeeper，因此集群中所有Kafka节点会相互投票选择出存放和管理元数据的Controller节点，这个端口就是用于投票选举时的相互通信或者从Controller节点获取元数据，下文称之为**控制器端口**

上述除了`KAFKA_HOST`和`KAFKA_PORT`和前面的意义相同之外，其它配置说明如下：

- `CLUSTER_ID` 集群`id`，一个集群内所有的节点配置的集群`id`必须相同
- `NODE_ID` 节点`id`，一个集群内所有节点`id`不能够重复，且这个`id`需要是不小于`1`的整数（类似上述Zookeeper的`BROKER_ID`配置）
- `VOTER_LIST` 投票者列表，也就是配置**整个集群中所有的Controller节点和混合节点列表**（不需要将Broker节点配置进去），配置格式为`节点1的id@节点1地址:节点1端口,节点2的id@节点2地址:节点2端口,节点3的id@节点3地址:节点3端口...`，这里端口要写节点的**控制器端口**

下面给出2个示例。

##### a. 全混合节点集群

假设要在**三台服务器**上面配置下列集群，集群`id`为`YWJjZGVmZ2hpamtsbW5vcA==`：

| 节点`id` | 节点外网地址 | 节点类型 | 容器`9092`端口映射到的宿主机端口 | 容器`9093`端口映射到的宿主机端口 |
| :------: | :----------: | :------: | :------------------------------: | :------------------------------: |
|   `1`    |   `kafka1`   | 混合节点 |              `9001`              |             `10001`              |
|   `2`    |   `kafka2`   | 混合节点 |              `9002`              |             `10002`              |
|   `3`    |   `kafka3`   | 混合节点 |              `9003`              |             `10003`              |

则依次在三台服务器上面执行命令：

```bash
# 服务器1
docker run -id --name=kafka -p 9001:9092 -p 10001:9093 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e CLUSTER_ID=YWJjZGVmZ2hpamtsbW5vcA== \
-e KAFKA_HOST=kafka1 \
-e KAFKA_PORT=9001 \
-e NODE_ID=1 \
-e VOTER_LIST=1@kafka1:10001,2@kafka2:10002,3@kafka3:10003 \
-e NUM_PARTITIONS=3 \
swsk33/kafka-standalone

# 服务器2
docker run -id --name=kafka -p 9002:9092 -p 10002:9093 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e CLUSTER_ID=YWJjZGVmZ2hpamtsbW5vcA== \
-e KAFKA_HOST=kafka2 \
-e KAFKA_PORT=9002 \
-e NODE_ID=2 \
-e VOTER_LIST=1@kafka1:10001,2@kafka2:10002,3@kafka3:10003 \
-e NUM_PARTITIONS=3 \
swsk33/kafka-standalone

# 服务器3
docker run -id --name=kafka -p 9003:9092 -p 10003:9093 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e CLUSTER_ID=YWJjZGVmZ2hpamtsbW5vcA== \
-e KAFKA_HOST=kafka3 \
-e KAFKA_PORT=9003 \
-e NODE_ID=3 \
-e VOTER_LIST=1@kafka1:10001,2@kafka2:10002,3@kafka3:10003 \
-e NUM_PARTITIONS=3 \
swsk33/kafka-standalone
```

##### b. 手动设定每个节点类型的集群

现在同样是要在**三台服务器**上面配置下列集群，集群`id`为`YWJjZGVmZ2hpamtsbW5vcA==`：

| 节点`id` | 节点外网地址 |  节点类型  | 容器`9092`端口映射到的宿主机端口 | 容器`9093`端口映射到的宿主机端口 |
| :------: | :----------: | :--------: | :------------------------------: | :------------------------------: |
|   `1`    |   `kafka1`   | Controller |              不暴露              |             `10001`              |
|   `2`    |   `kafka2`   |   Broker   |              `9002`              |              不暴露              |
|   `3`    |   `kafka3`   |   Broker   |              `9003`              |              不暴露              |

则依次在三台服务器上面执行命令：

```bash
# 服务器1
docker run -id --name=kafka -p 10001:9093 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e PROCESS_ROLE=controller \
-e CLUSTER_ID=YWJjZGVmZ2hpamtsbW5vcA== \
-e NODE_ID=1 \
-e VOTER_LIST=1@kafka1:10001 \
swsk33/kafka-standalone

# 服务器2
docker run -id --name=kafka -p 9002:9092 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e PROCESS_ROLE=broker \
-e CLUSTER_ID=YWJjZGVmZ2hpamtsbW5vcA== \
-e KAFKA_HOST=kafka2 \
-e KAFKA_PORT=9002 \
-e NODE_ID=2 \
-e VOTER_LIST=1@kafka1:10001 \
-e NUM_PARTITIONS=2 \
swsk33/kafka-standalone

# 服务器3
docker run -id --name=kafka -p 9003:9092 -v kafka-config:/kafka/config -v kafka-logs:/tmp/kafka-logs -v kraft-meta:/tmp/kraft-combined-logs \
-e PROCESS_ROLE=broker \
-e CLUSTER_ID=YWJjZGVmZ2hpamtsbW5vcA== \
-e KAFKA_HOST=kafka3 \
-e KAFKA_PORT=9003 \
-e NODE_ID=3 \
-e VOTER_LIST=1@kafka1:10001 \
-e NUM_PARTITIONS=2 \
swsk33/kafka-standalone
```

可见这里有下列注意事项：

- `KAFKA_HOST`和`KAFKA_PORT`都是**Kafka对外广播的该节点的外网地址和端口**，当客户端连接这个Kafka节点时，先会从该节点Kafka广播的外网地址和端口尝试连接到Kafka，所以`KAFKA_HOST`要填写所在服务器外网地址或者域名，而`KAFKA_PORT`要填写容器`9092`端口映射到的宿主机的端口，否则客户端不能正确通过服务器访问到Kafka容器
- Controller节点**不需要**配置`KAFKA_HOST`和`KAFKA_PORT`这两项，而Broker节点和混合节点必须要配置这两项
- `VOTER_LIST`中的地址也是需要填写Kafka的Controller或者混合节点所在服务器外网地址，端口则是每个节点的投票通信端口`9093`所映射到的宿主机端口，这样所有的Kafka节点之间才能通过外网正确地互相通信，该配置中的节点列表只包含Controller节点或者混合节点（同时担任Broker和Controller角色的节点）
- 这里的示例将`9092`和`9093`映射至宿主机其它端口上了，主要是需要大家明白`KAFKA_HOST`、`KAFKA_PORT`和`VOTER_LIST`中配置的地址和端口与宿主机映射端口的对应关系，在生产环境中建议直接把容器`9092`和`9093`端口映射至宿主机上同样的端口号上去，方便操作

## 3， 全部环境变量配置项

这里列出所有的可以通过指定环境变量来完成配置的配置项：

|      环境变量名       | 生效的集群模式  |                           配置意义                           |       默认值        |
| :-------------------: | :-------------: | :----------------------------------------------------------: | :-----------------: |
|    `ZOOKEEPER_URL`    | 仅Zookeeper模式 |             `Kafka`所使用的Zookeeper的地址和端口             |  `127.0.0.1:2181`   |
|      `BROKER_ID`      | 仅Zookeeper模式 | `Kafka`节点`id`，用于区分同一集群中不同节点（Zookeeper模式） |         `0`         |
|     `CLUSTER_ID`      |   仅KRaft模式   |      `Kafka`的集群`id`，同一个集群中节点的集群`id`相同       |  `""`（空字符串）   |
|       `NODE_ID`       |   仅KRaft模式   |   `Kafka`节点`id`，用于区分同一集群中不同节点（KRaft模式）   |         `1`         |
|     `VOTER_LIST`      |   仅KRaft模式   |        投票者列表，也就是配置整个集群中所有的节点列表        | `1@127.0.0.1:9093`  |
|    `PROCESS_ROLE`     |   仅KRaft模式   | 节点的类型，设置为`broker`或者`controller`分别表示节点为Broker节点和Controller节点，也可以是`broker,controller`表示混合节点 | `broker,controller` |
|     `KAFKA_HOST`      |    全部模式     |            `Kafka`所在的服务器的外网地址或者域名             |     `127.0.0.1`     |
|     `KAFKA_PORT`      |    全部模式     |                `Kafka`所在的服务器的外网端口                 |       `9092`        |
|  `SEND_BUFFER_BYTE`   |    全部模式     |           每次发送的数据包的最大大小（单位：字节）           |      `102400`       |
| `RECEIVE_BUFFER_BYTE` |    全部模式     |           每次接收的数据包的最大大小（单位：字节）           |      `102400`       |
|  `REQUEST_MAX_BYTES`  |    全部模式     |               接收的最大请求大小（单位：字节）               |     `104857600`     |
|   `NUM_PARTITIONS`    |    全部模式     |                   每个`Topic`的默认分区数                    |         `1`         |

如果不需要改变某个配置的值，就不需要在容器创建时指定这个环境变量，其它配置可以通过修改配置文件的方式完成，修改配置文件的方式见下一节。

## 4，数据清除

如果遇到容器无法启动等情况，可以先停止容器，然后清空数据再试。

按照上述所有命令完成配置后，数据文件的数据卷位置如下：

- `Kafka`消息数据：`/var/lib/docker/volumes/kafka-logs/_data`
- `KRaft`元数据信息：`/var/lib/docker/volumes/kraft-meta/_data`

停止容器后，执行下列命令删除所有容器数据：

```bash
rm -rf /var/lib/docker/volumes/kafka-logs/_data/*
rm -rf /var/lib/docker/volumes/kraft-meta/_data/*
```

再启动容器。

## 5，配置文件

根据上述配置之后，配置文件数据卷位于`/var/lib/docker/volumes/kafka-config/_data`目录下，可以按需修改其中的配置文件，然后重启容器即可。

配置文件官方文档：[传送门](https://kafka.apache.org/documentation/#configuration)

## 6，常用命令

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