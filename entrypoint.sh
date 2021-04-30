#!/bin/sh
DEFAULT_GATEWAY=$(ip route show default | cut -d' ' -f3)
if [ -z "$HG_USER" ] || [ -z "$HG_PASS" ]; then
	echo Missing Honeygain credentials
	exit 1
fi
if [ -z "$HG_NAME" ]; then
	HG_NAME=$(hostname)
	echo "HG_NAME not provided, using hostname as device name ($HG_NAME)"
fi
if [ -z "$SOCKS_HOST" ]; then
	SOCKS_HOST="$DEFAULT_GATEWAY"
fi
case "$SOCKS_HOST" in
	*":"*) ;;
	    *) SOCKS_HOST="${SOCKS_HOST}:${SOCKS_PORT}"
esac
echo "nameserver $DNS_SERVER" >/etc/resolv.conf
ip tuntap add dev tun0 mode tun
ip addr replace 10.0.0.1/24 dev tun0
ip link set dev tun0 up
ip route add "$DNS_SERVER" via "$DEFAULT_GATEWAY" metric 5
ip route del default
ip route add default via 10.0.0.1 dev tun0 metric 6

exec chroot --userspec=app:app / sh -c "cd $PWD && exec $@"
