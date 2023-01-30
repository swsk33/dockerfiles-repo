FROM alpine
RUN apk update \
	&& apk add openssl curl ca-certificates \
	&& wget -P /etc/apk/keys/ https://cdn.azul.com/public_keys/alpine-signing@azul.com-5d5dc44c.rsa.pub \
	&& wget -P /etc/apk/keys/ https://nginx.org/keys/nginx_signing.rsa.pub \
	&& printf "%s%s%s%s\n" "@nginx " "http://nginx.org/packages/alpine/v" `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` "/main" | tee -a /etc/apk/repositories \
	&& echo "https://repos.azul.com/zulu/alpine" | tee -a /etc/apk/repositories \
	&& apk update \
	&& apk --no-cache add nginx@nginx zulu17-ca-jre-headless \
	&& rm -rf /var/cache/apk/*
ENV LANG C.UTF-8
EXPOSE 80
EXPOSE 443
VOLUME ["/etc/nginx", "/var/log/nginx"]
CMD ["nginx", "-g", "daemon off;"]