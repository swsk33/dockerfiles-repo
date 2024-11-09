FROM debian
# 准备环境
# 替换软件源
RUN echo "Types: deb" > /etc/apt/sources.list.d/debian.sources \
	&& echo "URIs: http://mirror.tuna.tsinghua.edu.cn/debian" >> /etc/apt/sources.list.d/debian.sources \
	&& echo "Suites: bookworm bookworm-updates bookworm-proposed-updates bookworm-backports bookworm-backports-sloppy" >> /etc/apt/sources.list.d/debian.sources \
	&& echo "Components: main contrib non-free non-free-firmware" >> /etc/apt/sources.list.d/debian.sources \
	&& echo "Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg" >> /etc/apt/sources.list.d/debian.sources \
	# 安装证书
	&& apt update \
	&& apt install -y ca-certificates \
	# 修改软件源
	&& sed -i 's/http/https/g' /etc/apt/sources.list.d/debian.sources \
	&& dpkg --add-architecture i386 \
	&& apt update \
	&& apt full-upgrade -y \
	# 安装下载器
	&& apt install -y wget \
	# 安装OSS
	&& wget -O /oss.deb http://www.opensound.com/release/oss-linux-v4.2-2020-amd64.deb \
	&& apt install -y /oss.deb \
	# 安装必要构建环境
	&& apt install -y flex bison make gcc-multilib gcc-mingw-w64 gettext \
	libasound2-dev libasound2-dev:i386 \
	libpulse-dev libpulse-dev:i386 \
	libdbus-1-dev libdbus-1-dev:i386 \
	libfontconfig-dev libfontconfig-dev:i386 \
	libfreetype-dev libfreetype-dev:i386 \
	libgnutls28-dev libgnutls28-dev:i386 \
	libgl-dev libgl-dev:i386 \
	libunwind-dev libunwind-dev:i386 \
	libx11-dev libx11-dev:i386 \
	libxcomposite-dev libxcomposite-dev:i386 \
	libxcursor-dev libxcursor-dev:i386 \
	libxfixes-dev libxfixes-dev:i386 \
	libxi-dev libxi-dev:i386 \
	libxrandr-dev libxrandr-dev:i386 \
	libxrender-dev libxrender-dev:i386 \
	libxext-dev libxext-dev:i386 \
	libwayland-bin \
	libwayland-dev libwayland-dev:i386 \
	libegl-dev libegl-dev:i386 \
	libxkbcommon-dev libxkbcommon-dev:i386 \
	libxkbregistry-dev libxkbregistry-dev:i386 \
	libgstreamer1.0-dev libgstreamer1.0-dev:i386 libgstreamer-plugins-base1.0-dev \
	libosmesa6-dev libosmesa6-dev:i386 \
	libsdl2-dev libsdl2-dev:i386 \
	libudev-dev libudev-dev:i386 \
	libvulkan-dev libvulkan-dev:i386 \
	libcapi20-dev libcapi20-dev:i386 \
	libcups2-dev libcups2-dev:i386 \
	libgphoto2-dev libgphoto2-dev:i386 \
	libsane-dev libsane-dev:i386 \
	libkrb5-dev libkrb5-dev:i386 \
	samba-dev samba-dev:i386 \
	ocl-icd-opencl-dev ocl-icd-opencl-dev:i386 \
	libpcap-dev libpcap-dev:i386 \
	libusb-1.0-0-dev libusb-1.0-0-dev:i386 \
	libv4l-dev libv4l-dev:i386 \
	libpcsclite-dev libpcsclite-dev:i386 \
	# 执行清理
	&& apt purge -y wget \
	&& apt autoremove -y \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/* /oss.deb \
	# 创建工作目录
	&& mkdir /wine
VOLUME ["/wine"]
WORKDIR /wine
CMD ["bash"]