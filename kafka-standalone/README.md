# Kafka单机镜像

这是一个Kafka的单机镜像，可用于快速地部署一个单机Kafka实例。

- Kafka官方文档：[传送门](https://kafka.apache.org/documentation/)
- Dockerfile文件：[传送门](https://github.com/swsk33/dockerfiles-repo/blob/master/kafka-standalone/latest/Dockerfile)

# 说明

## 1，创建数据卷

拉取容器后，创建容器之前先创建个具名数据卷用于持久化Kafka的**配置文件**，也以便于我们后续可以修改：

```bash
docker volume create kafka-config
```

## 2，创建并运行容器

使用以下命令创建容器：

```bash
docker run -id --name=kafka -p 9092:9092 -v kafka-config:/kafka/config swsk33/kafka-standalone
```

## 3，修改配置文件

根据上述配置之后，配置文件数据卷位于`/var/lib/docker/volumes/kafka-config/_data`目录下，可以按需修改其中的配置文件，然后重启容器即可。

配置文件官方文档：[传送门](https://kafka.apache.org/documentation/#configuration)

## 4，常用命令

上述创建的容器名为`kafka`，若你的容器名不是这个，请在下列命令中把`kafka`替换成自己的容器名。

### (1) 日志查看

查看Kafka实时日志：

```bash
docker logs -f kafka
```

查看内置Zookeeper实时日志：

```bash
docker exec -it kafka tail -f zookeeper.log
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