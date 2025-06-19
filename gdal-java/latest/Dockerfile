# 构建参数：Java版本
ARG build_java_version=17

# 阶段1：构建
FROM bellsoft/liberica-openjdk-debian:${build_java_version} AS builder
# 初始化软件源
ADD debian.sources /etc/apt/sources.list.d/debian.sources
ADD pgdg.list /etc/apt/sources.list.d/pgdg.list
ADD postgresql.asc /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
RUN apt update
RUN apt full-upgrade -y
# 安装编译所需工具
RUN apt install -y aria2 \
	build-essential cmake swig ant python3 python3-dev python3-setuptools python3-numpy \
	libproj-dev libarchive-dev libarmadillo-dev libghc-arrows-dev libblosc-dev \
	libcurl4-gnutls-dev libcrypto++-dev libdeflate-dev libexpat1-dev libfreexl-dev \
	libfyba-dev libgeotiff-dev libgeos-dev libgif-dev libheif-dev \
	libhdf4-dev libhdf5-dev libjpeg-dev libtiff-dev libpng-dev libkml-dev libnetcdf-dev \
	libjson-c-dev libjxl-dev liblerc-dev libaec-dev \
	liblzma-dev libxml2-dev liblz4-dev libmuparser-dev \
	libmysql++-dev libmariadb-dev libpq-dev \
	libopenexr-dev libopenjp2-7-dev libssl-dev libpcre2-dev \
	libpoppler-dev libqhull-dev librasterlite2-dev libspatialite-dev \
	libsqlite3-dev libsfcgal-dev libwebp-dev libxerces-c-dev \
	zlib1g-dev libzstd-dev
# 下载解压源码
RUN aria2c -x 16 -s 16 -o /gdal.tar.gz "https://github.com/OSGeo/gdal/releases/download/v3.11.0/gdal-3.11.0.tar.gz"
RUN mkdir /gdal-src /gdal-install
RUN tar -xvf /gdal.tar.gz --strip-components=1 -C /gdal-src
# 开始构建
RUN cd /gdal-src \
	&& mkdir build \
	&& cd build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/gdal-install -DBUILD_JAVA_BINDINGS=ON .. \
	&& make -j $(nproc) \
	&& make install

# 阶段2：运行环境
FROM bellsoft/liberica-openjre-debian:${build_java_version}
# 初始化软件源
ADD debian.sources /etc/apt/sources.list.d/debian.sources
ADD pgdg.list /etc/apt/sources.list.d/pgdg.list
ADD postgresql.asc /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
ENV DEBIAN_FRONTEND=noninteractive
# 安装运行依赖
RUN apt update \
	&& apt full-upgrade -y \
	&& apt install -y tzdata \
	libproj25 libarchive13 libarmadillo11 \
	libblosc1 libcurl4 libcrypto++8 libdeflate0 libexpat1 \
	libfreexl1 libfyba0 libgeotiff5 libgeos3.11.1 libgeos-c1v5 \
	libgif7 libheif1 libhdf4-0 libhdf5-103-1 libjpeg62-turbo \
	libtiff6 libpng16-16 libnetcdf19 \
	libkmlbase1 libkmldom1 libkmlengine1 \
	libjson-c5 libjxl0.7 liblerc4 libaec0 \
	liblzma5 libxml2 liblz4-1 libmuparser2v5 \
	libmysql++3v5 libmariadb3 libpq5 \
	libopenexr-3-1-30 libopenjp2-7 libssl3 \
	libpcre2-8-0 libpcre2-16-0 libpcre2-32-0 libpcre2-posix3 \
	libpoppler126 libqhull8.0 libqhull-r8.0 libqhullcpp8.0 \
	librasterlite2-1 libspatialite7 libsqlite3-0 libsfcgal1 \
	libwebp7 libxerces-c3.2 zlib1g libzstd1 \
	&& apt autopurge -y \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*
# 拷贝程序
COPY --from=builder /gdal-install/. /usr/local/
# 配置环境变量
# 运行库环境变量
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV GDAL_DATA=/usr/local/share/gdal
ENV JAVA_TOOL_OPTIONS="-Djava.library.path=/usr/local/lib:/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib:/usr/local/lib/jni"
# 系统环境变量
ENV TZ="Asia/Shanghai"
ENV LANG=C.UTF-8
CMD ["bash"]