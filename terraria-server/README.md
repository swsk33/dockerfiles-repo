# 泰拉瑞亚服务端

可以快速地启动一个泰拉瑞亚服务端。

# 说明

## 1，创建数据卷

拉取容器后，创建容器之前先创建两个具名数据卷用于持久化世界存档文件和配置文件：

```bash
docker volume create terraria-config
docker volume create terraria-world
```

上述创建了两个名为`terraria-config`和`terraria-world`的具名数据卷，分别用于映射和持久化容器中的服务端配置和世界存档文件。

## 2，创建容器

使用以下命令创建容器：

```bash
docker run -itd --name=terraria-server -p 7777:7777 -v terraria-config:/terraria/config -v terraria-world:/terraria/world swsk33/terraria-server
```

此时服务端已经启动，使用泰拉瑞亚游戏多人游戏-通过IP连接连接服务器即可。

## 3，修改配置文件

根据上述配置之后，配置文件数据卷位于`/var/lib/docker/volumes/terraria-config/_data/config.txt`，修改这个文件然后重启服务端即可。配置项参考[官方文档](https://terraria.wiki.gg/wiki/Server#Server_config_file)。

## 4，正确地停止服务端

由于泰拉瑞亚服务端是交互式的，因此我们不能直接通过`docker stop`或者`docker restart`命令来停止和重启容器，否则可能导致服务端数据丢失。

先通过以下命令连接容器内服务端的交互式控制台：

```bash
docker attach terraria-server
```

此时就进入了泰拉瑞亚服务端的交互式控制台，可能你会发现连接上后并没有显示服务端先前在控制台输出的内容，看起来像卡死了一样的，但是事实上你已经成功连接上了服务端控制台，可以直接输入泰拉瑞亚服务端的指令，这时你试着输入`help`试试，能够如你所愿。

输入`save`命令可以保存世界，若要停止服务端输入`exit`，这时服务端和容器都会停止，并回到宿主机终端。再次启动时使用`docker start`命令即可。修改配置文件之后就需要通过这种方式退出停止服务端并重新启动。

进入容器内泰拉瑞亚服务端控制台后，如果想退出容器但是仍然保持容器运行，依次按下Ctrl + P和Ctrl + Q组合键即可。

## 5，关于世界

根据上述配置之后，世界存档数据卷位于`/var/lib/docker/volumes/terraria-world/_data/main.wld`，如果想重新生成世界，可以先按照上述方式停止服务端，然后删除该文件，再重启容器即可。

如果想使用自己的世界，同样地停止服务端后，就把你的世界存档文件改为`main.wld`覆盖至上述目录再启动容器。