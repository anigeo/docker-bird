FROM alpine:latest

ENV BIRD_VERSION 2.0.2

RUN set -ex \
	&& apk upgrade --no-cache \
	&& apk add --no-cache iproute2 \
	&& apk add --no-cache --virtual .build-deps \
		git \
		autoconf \
		automake \
		build-base \
		bison \
		flex \
		linux-headers \
	&& git clone --branch v${BIRD_VERSION} --single-branch https://gitlab.labs.nic.cz/labs/bird.git \
	&& cd bird \
	&& rm -rf .git \
	&& sed -i 's|18, "Input/output error"|9, "I/O error"|' lib/printf_test.c \
	&& aclocal \
	&& autoconf \
	&& autoheader \
	&& ./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--disable-client \
	&& make \
	&& make test \
	&& /usr/bin/install -c ./bird /usr/sbin/bird \
	&& /usr/bin/install -c ./birdcl /usr/sbin/birdcl \
	&& sed 's/syslog/stderr/g' doc/bird.conf.example > /etc/bird.conf \
	&& cd .. \
	&& rm -rf bird \
	&& apk del --no-cache --purge --rdepends .build-deps \
	&& /usr/sbin/bird --version

ENTRYPOINT ["/usr/sbin/bird", "-f"]
