FROM debian:bullseye-slim
COPY terraria.zip /
ADD sources.list /etc/apt/sources.list
RUN apt update \
	&& apt install -y unzip \
	&& unzip -d / /terraria.zip \
	&& mkdir /terraria \
	&& mkdir /terraria/world \
	&& mkdir /terraria/config \
	&& cp -rf /1449/Linux/* /terraria/ \
	&& chmod +x /terraria/TerrariaServer.bin.x86_64 \
	&& rm -rf terraria.zip 1449/ \
	&& apt purge -y unzip \
	&& apt autoremove -y \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*
ADD config.txt /terraria/config/
ENV LANG C.UTF-8
EXPOSE 7777
VOLUME ["/terraria/world", "/terraria/config"]
WORKDIR /terraria
CMD ["./TerrariaServer.bin.x86_64", "-config", "./config/config.txt"]