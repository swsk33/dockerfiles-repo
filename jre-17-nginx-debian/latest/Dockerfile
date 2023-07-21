FROM debian:bookworm-slim
RUN apt update \
	&& apt install -y --no-install-recommends gnupg gnupg2 ca-certificates curl lsb-release debian-archive-keyring \
	&& mkdir /keys \
	&& curl --noproxy '*' -o /keys/azul.key https://repos.azul.com/azul-repo.key \
	&& gpg --dearmor -o /usr/share/keyrings/azul.gpg < /keys/azul.key \
	&& curl --noproxy '*' -o /keys/nginx.key https://nginx.org/keys/nginx_signing.key \
	&& gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg < /keys/nginx.key \
	&& echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list \
	&& echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian bookworm nginx" | tee /etc/apt/sources.list.d/nginx.list \
	&& apt update \
	&& apt install -y --no-install-recommends nginx zulu17-ca-jre-headless \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/* /keys/
ENV LANG C.UTF-8
EXPOSE 80
EXPOSE 443
VOLUME ["/etc/nginx", "/var/log/nginx"]
CMD ["nginx", "-g", "daemon off;"]