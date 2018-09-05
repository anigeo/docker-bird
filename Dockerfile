FROM alpine:latest

RUN \
	apk upgrade --no-cache && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	apk add --no-cache bird && \
	sed -i 's/syslog/stderr/g' /etc/bird.conf

ENTRYPOINT ["/usr/sbin/bird", "-f"]
