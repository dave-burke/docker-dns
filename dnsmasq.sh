#!/bin/bash

NIC="eno1"

MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

IMAGE="andyshinn/dnsmasq"

docker pull ${IMAGE} 
docker rm -f dns
docker run --detach --restart always --name dns \
	-p $MY_IP:53:53/tcp -p $MY_IP:53:53/udp \
	--cap-add=NET_ADMIN \
	${IMAGE}:2.75 \
	--log-facility=- \
	--address /${HOST}.lan/$MY_IP \
	--domain-needed \
	--bogus-priv \
	--expand-hosts

