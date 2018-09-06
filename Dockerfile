FROM debian:buster-slim

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install --no-install-recommends -y iproute2 bird && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
