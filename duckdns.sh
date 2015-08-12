#!/bin/sh

# Duck DNS variables
export SUBDOMAIN=
export TOKEN=

# script variables
export CMD=$1
export INTERFACE=$2

function global_ip () {
	echo `dig +short myip.opendns.com @resolver1.opendns.com`
}

function interface_ip () {
	echo `ifconfig $1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
}

function list_interfaces () {
	echo
	echo "Bind options:"
	echo "\tpublic\t- $(global_ip)"

	for inter in `ifconfig -l`; do
		local IP=$(interface_ip $inter)
		if [ "${IP}" != "" ]; then
			echo "\t$inter\t- ${IP}"
		fi
	done
	echo
}

function show_help () {
	echo
	echo "Commands:"
	echo "bind or -b $interface"
	echo "\tBinds Duck DNS address to interface IP address\n"
	echo "list or -l"
	echo "\tLists available interfaces to bind\n"
}

function bind_ip () {
	local IP=$1
	local "URL=https://www.duckdns.org/update?domains=${SUBDOMAIN}&token=${TOKEN}&ip=${IP}"

	if [ "$IP" = "" ]; then
		echo "IP Address was not found on interface $INTERFACE"
		echo
		return
	fi

	if [ "`curl --silent $URL`" = "OK" ]; then
		echo "Duckdns was successfully updated to ${IP}"
	else
		echo "Duckdns update failed for $INTERFACE ${IP}"
		echo
		echo $URL
		echo
	fi
}

if [ "$CMD" = "bind" ] || [ "$CMD" = "-b" ]; then
	if [ "$INTERFACE" = "" ]; then
		echo "Please define an interface to bind"
		echo
		exit
	elif [ "$INTERFACE" = "public" ]; then
		export IP=$(global_ip)

		echo "Trying to bind duckdns to public IP: ${IP}"
		echo

		bind_ip $IP
	else
		export IP=$(interface_ip $INTERFACE)

		echo
		echo "Trying to bind duckdns to interface $INTERFACE - $IP"
		echo

		bind_ip $IP
	fi
elif [ "$CMD" = "list" ] || [ "$CMD" = "-l" ]; then
	list_interfaces
else
	show_help
fi
