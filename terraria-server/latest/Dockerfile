FROM debian:bullseye-slim
RUN apt update \
	&& apt install -y --no-install-recommends unzip wget ca-certificates \
	&& wget -O terraria.zip https://www.terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip \
	&& unzip -d / /terraria.zip \
	&& mkdir /terraria \
	&& mkdir /terraria/world \
	&& mkdir /terraria/config \
	&& cp -rf /1449/Linux/* /terraria/ \
	&& chmod +x /terraria/TerrariaServer.bin.x86_64 \
	&& apt purge -y unzip wget ca-certificates \
	&& apt autoremove -y \
	&& apt clean \
	&& rm -rf terraria.zip 1449/ /var/lib/apt/lists/*
ADD config.txt /terraria/config/
ENV LANG C.UTF-8
EXPOSE 7777
VOLUME ["/terraria/world", "/terraria/config"]
WORKDIR /terraria
CMD ["./TerrariaServer.bin.x86_64", "-config", "./config/config.txt"]