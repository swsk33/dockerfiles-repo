FROM debian
# 准备环境
RUN rm /etc/apt/sources.list.d/* \
	# 配置软件源
	&& echo "deb http://deb.debian.org/debian bookworm main non-free non-free-firmware contrib" > /etc/apt/sources.list \
	&& echo "deb http://deb.debian.org/debian bookworm-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
	&& echo "deb http://deb.debian.org/debian bookworm-proposed-updates main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
	&& echo "deb http://deb.debian.org/debian bookworm-backports main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
	&& echo "deb http://deb.debian.org/debian bookworm-backports-sloppy main non-free non-free-firmware contrib" >> /etc/apt/sources.list \
	&& dpkg --add-architecture i386 \
	&& apt update \
	&& apt full-upgrade -y \
	# 安装下载器
	&& apt install -y aria2 \
	# 安装OSS
	&& aria2c -o /oss.deb http://www.opensound.com/release/oss-linux-v4.2-2020-amd64.deb \
	&& apt install -y /oss.deb \
	&& apt purge -y aria2 \
	# 安装必要构建环境
	&& apt install -y flex bison make gcc-multilib gcc-mingw-w64 gettext \
	libx11-dev libx11-dev:i386 \
	libfontconfig-dev libfontconfig-dev:i386 \
	libfreetype-dev libfreetype-dev:i386 \
	libxcursor-dev:i386 libxcursor-dev \
	libx11-dev:i386 libx11-dev \
	libxrandr-dev:i386 libxrandr-dev \
	libxcomposite-dev:i386 libxcomposite-dev \
	libxfixes-dev:i386 libxfixes-dev \
	libxrender-dev:i386 libxrender-dev \
	libxml2-dev:i386 libxml2-dev \
	libjpeg-dev:i386 libjpeg-dev \
	libldap-dev:i386 libldap-dev \
	libtiff-dev:i386 libtiff-dev \
	libmpg123-dev:i386 libmpg123-dev \
	libopenal-dev:i386 libopenal-dev \
	libudev-dev:i386 libudev-dev \
	libfaudio-dev:i386 libfaudio-dev \
	libpcap-dev:i386 libpcap-dev \
	libdbus-1-dev:i386 libdbus-1-dev \
	libsane-dev:i386 libsane-dev \
	libusb-1.0-0-dev:i386 libusb-1.0-0-dev \
	libgphoto2-dev:i386 libgphoto2-dev \
	libpulse-dev:i386 libpulse-dev \
	libkrb5-dev:i386 libkrb5-dev \
	libcapi20-dev:i386 libcapi20-dev \
	libcups2-dev:i386 libcups2-dev \
	libv4l-dev:i386 libv4l-dev \
	libosmesa6-dev:i386 libosmesa6-dev \
	libvulkan-dev:i386 libvulkan-dev \
	libvkd3d-dev:i386 libvkd3d-dev \
	ocl-icd-opencl-dev ocl-icd-opencl-dev:i386 \
	libxslt1-dev libxslt1-dev:i386 \
	libgstreamer1.0-dev libgstreamer1.0-dev:i386 libgstreamer-plugins-base1.0-dev \
	libgnutls28-dev libgnutls28-dev:i386 \
	samba-dev samba-dev:i386 \
	liblcms2-dev:i386 liblcms2-dev \
	libgsm1-dev:i386 libgsm1-dev \
	libsdl2-dev:i386 libsdl2-dev \
	libglu1-mesa-dev libglu1-mesa-dev:i386 \
	libncurses-dev libncurses-dev:i386 \
	# 执行清理
	&& apt autoremove -y \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/* /oss.deb \
	# 创建工作目录
	&& mkdir /wine
VOLUME ["/wine"]
WORKDIR /wine
CMD ["bash"]