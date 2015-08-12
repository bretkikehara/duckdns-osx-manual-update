#!/bin/sh

# Duck DNS variables
export DOMAIN=
export TOKEN=

# script variables
export INTERFACE=$1

function global_ip () {
	echo `dig +short myip.opendns.com @resolver1.opendns.com`
}

function interface_ip () {
	echo `ifconfig $1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
}

if [ "$INTERFACE" == "public" ]; then
	export IP=$(global_ip)

	echo "Trying to bind duckdns to public IP: ${IP}"
	echo
elif [ "$INTERFACE" != "" ]; then
	export IP=$(interface_ip $INTERFACE)

	echo
	echo "Trying to bind duckdns to interface $INTERFACE - $IP"
	echo
else
	echo "Bind options:"
	echo "public\t- $(global_ip)"

	for inter in `ifconfig -l`; do
		export IP=$(interface_ip $inter)
		if [ "${IP}" != "" ]; then
			echo "$inter\t- ${IP}"
		fi
	done

	exit
fi

if [ "$IP" = "" ]; then
	echo "IP Address was not found on interface $INTERFACE"
	echo
	exit
fi

export "URL=https://www.duckdns.org/update?domains=${DOMAIN}&token=${TOKEN}&ip=${IP}"

if [ "`curl --silent $URL`" = "OK" ]; then
	echo "Duckdns was successfully updated to ${IP}"
else
	echo "Duckdns update failed for $INTERFACE ${IP}"
	echo
	echo $URL
	echo
fi

echo
echo
