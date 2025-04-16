FROM bellsoft/liberica-openjre-alpine:21
# 添加脚本
ADD start.sh /
# 设定环境变量
ENV LANG=C.UTF-8
ENV SPARK_HOME=/opt/spark
ENV LIVY_HOME=/opt/livy
# 安装必备环境
RUN apk add --no-cache aria2 bash procps \
	# 下载Spark和Livy
	&& aria2c -o /spark.tgz https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz \
	&& aria2c -o /livy.zip https://dlcdn.apache.org/incubator/livy/0.8.0-incubating/apache-livy-0.8.0-incubating_2.12-bin.zip \
	# 解压Spark和Livy
	&& mkdir -p ${SPARK_HOME} \
	&& tar -xvf /spark.tgz --strip-components=1 -C ${SPARK_HOME} \
	&& unzip /livy.zip -d /opt/ \
	&& mv /opt/$(ls /opt | grep apache-livy) ${LIVY_HOME} \
	# 权限调整
	&& chmod +x /start.sh \
	# 清理
	&& rm /spark.tgz /livy.zip \
	&& apk del aria2
# 工作目录
WORKDIR ${LIVY_HOME}
# 数据卷
VOLUME ["${LIVY_HOME}/conf"]
CMD ["/start.sh"]