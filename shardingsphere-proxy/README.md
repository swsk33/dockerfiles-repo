# ShardingSphere-Proxy镜像

这是一个ShardingSphere-Proxy的Docker镜像，可用于快速地部署一个单机ShardingSphere-Proxy实例，并且也支持集群配置，已集成MySQL连接驱动。

- 官方文档：[传送门](https://shardingsphere.apache.org/document/current/cn/overview/)
- Dockerfile文件：[传送门](https://github.com/swsk33/dockerfiles-repo/blob/master/shardingsphere-proxy/latest/Dockerfile)

# 说明

## 1，创建数据卷

拉取容器后，创建容器之前先创建下列具名数据卷，用于持久化配置文件、日志和外部库：

```bash
docker volume create shardingsphere-config
docker volume create shardingsphere-logs
docker volume create shardingsphere-extlib
```

## 2，创建并运行容器

使用以下命令创建容器：

```bash
docker run -id --name=shardingsphere-proxy \
	-p 3307:3307 \
	-v shardingsphere-config:/shardingsphere-proxy/conf \
	-v shardingsphere-extlib:/shardingsphere-proxy/ext-lib \
	-v shardingsphere-logs:/shardingsphere-proxy/logs \
swsk33/shardingsphere-proxy-standalone
```

## 3，修改配置文件并重启

由于默认配置是无效的，因此启动容器之后，ShardingSphere-Proxy实质上没有运行，因此需要修改配置文件后使用`docker restart`命令重启容器。

根据上述配置之后，全部配置文件数据卷位于`/var/lib/docker/volumes/shardingsphere-config`，按照[官方文档](https://shardingsphere.apache.org/document/current/cn/user-manual/shardingsphere-proxy/yaml-config/)配置即可。

重启后通过`docker logs -f`命令查看日志，确保最后一行输出为`ShardingSphere-Proxy Standalone mode started successfully`则启动成功。