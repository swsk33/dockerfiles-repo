# Minecraft原版服务端

可以快速地启动一个Minecraft原版服务端。

# 说明

## 1，创建数据卷

拉取容器后，创建容器之前先创建个具名数据卷用于持久化世界存档文件和配置文件等等，也便于我们修改：

```bash
docker volume create minecraft-data
```

这样，就将全部服务端文件持久化到了宿主机。

## 2，创建容器

通过下列命令：

```bash
docker run -itd --name=minecraft-server -p 25565:25565 -v minecraft-data:/minecraft-server swsk33/minecraft-server
```

第一次需要等待世界创建，过几分钟服务端即启动，可以通过游戏连接。

## 3，修改配置文件

通过上述配置数据卷之后，配置文件位于：`/var/lib/docker/volumes/minecraft-data/_data/server.properties`，使用文本编辑器编辑即可。编辑完成需要重启服务端，正确地停止并重启服务端请看下面说明。

## 4，正确地停止服务端

由于Minecraft服务端是交互式的，因此我们不能直接通过`docker stop`或者`docker restart`命令来停止和重启容器，否则可能导致服务端数据丢失。

先通过以下命令连接容器内服务端的交互式控制台：

```bash
docker attach minecraft-server
```

此时就进入了Minecraft服务端的交互式控制台，可能你会发现连接上后并没有显示服务端先前在控制台输出的内容，看起来像卡死了一样的，但是事实上你已经成功连接上了服务端控制台，可以直接输入Minecraft服务端的指令，这时你试着输入`/help`试试，能够如你所愿。

输入`/save-all`命令可以保存世界，若要停止服务端输入`/stop`，这时服务端和容器都会停止，并回到宿主机终端。再次启动时使用`docker start`命令即可。修改配置文件之后就需要通过这种方式退出停止服务端并重新启动。

进入容器内Minecraft服务端控制台后，如果想退出容器但是仍然保持容器运行，依次按下Ctrl + P和Ctrl + Q组合键即可。

## 5，关于世界

根据上述配置之后，世界存档数据卷位于`/var/lib/docker/volumes/minecraft-data/_data/world`目录，如果想重新生成世界，可以先按照上述方式停止服务端，然后删除该目录（`world`文件夹），再重启容器即可。

如果想使用自己的世界，同样地停止服务端后，先删除`/var/lib/docker/volumes/minecraft-data/_data`中的`world`目录，然后把你的世界存档目录改为`world`上传至该目录下，再启动容器即可。