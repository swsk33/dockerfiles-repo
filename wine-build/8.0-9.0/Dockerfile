FROM debian
ADD sources.list /etc/apt/sources.list
RUN rm /etc/apt/sources.list.d/* \
	&& dpkg --add-architecture i386 \
	&& apt update \
	&& apt full-upgrade -y \
	&& apt install -y aria2 \
	&& aria2c -o /oss.deb http://www.opensound.com/release/oss-linux-v4.2-2020-amd64.deb \
	&& apt install -y /oss.deb \
	&& apt purge -y aria2 \
	&& apt install -y flex bison make gcc-multilib gcc-mingw-w64 gettext \
	libasound2-dev libasound2-dev:i386 libpulse-dev libpulse-dev:i386 libdbus-1-dev libdbus-1-dev:i386 libfontconfig-dev libfontconfig-dev:i386 libfreetype-dev libfreetype-dev:i386 libgnutls28-dev libgnutls28-dev:i386 libgl-dev libgl-dev:i386 libunwind-dev libunwind-dev:i386 libx11-dev libx11-dev:i386 \
	libxcomposite-dev libxcomposite-dev:i386 libxcursor-dev libxcursor-dev:i386 libxfixes-dev libxfixes-dev:i386 libxi-dev libxi-dev:i386 libxrandr-dev libxrandr-dev:i386 libxrender-dev libxrender-dev:i386 libxext-dev libxext-dev:i386 \
	libgstreamer1.0-dev libgstreamer1.0-dev:i386 libgstreamer-plugins-base1.0-dev libosmesa6-dev libosmesa6-dev:i386 libsdl2-dev libsdl2-dev:i386 libudev-dev libudev-dev:i386 libvulkan-dev libvulkan-dev:i386 \
	libcapi20-dev libcapi20-dev:i386 libcups2-dev libcups2-dev:i386 libgphoto2-dev libgphoto2-dev:i386 libsane-dev libsane-dev:i386 libkrb5-dev libkrb5-dev:i386 samba-dev samba-dev:i386 ocl-icd-opencl-dev ocl-icd-opencl-dev:i386 \
	libpcap-dev libpcap-dev:i386 libusb-1.0-0-dev libusb-1.0-0-dev:i386 libv4l-dev libv4l-dev:i386 \
	&& apt autoremove -y \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/* /oss.deb \
	&& mkdir /wine
VOLUME ["/wine"]
WORKDIR /wine
CMD ["bash"]