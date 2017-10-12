#!/bin/bash

NIC="${1}"
DOMAIN="${2}"

[[ -n "${NIC}" ]] || { echo "First arg must be the nic"; exit 1; }

SELF="$(hostname)"
MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

IMAGE="andyshinn/dnsmasq"

addresses=" --address /${SELF}/${MY_IP} "
addresses+=$(grep "^192" /etc/hosts | awk -F '\t' '{print "--address /" $2 "/" $1}')
if [[ -n "${DOMAIN}" ]]; then
	addresses+=" --address /${SELF}.${DOMAIN}/${MY_IP} "
	addresses+=$(grep "^192" /etc/hosts | awk -F '\t' '{print "--address /" $2 ".'"${DOMAIN}"'/" $1}')
fi

docker pull ${IMAGE} 
docker rm -f dns

docker run --detach --restart always --name dns \
	-p $MY_IP:53:53/tcp -p $MY_IP:53:53/udp \
	--cap-add=NET_ADMIN \
	${IMAGE}:2.75 \
	--log-facility=- \
	${addresses} \
	--dns-forward-max 1000 \
	--domain-needed \
	--bogus-priv \
	--expand-hosts

