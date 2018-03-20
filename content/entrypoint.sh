#!/bin/sh -el

if [ -z "$*" -o "$1" = "-h" -o "$1" = "--help" ]; then
  # print usage
  echo "docker run <docker-options> <image> [-h|--help] -- print help"
  echo "docker run <docker-options> <image> openconnect <options> -- start a anyconnect tunnel"
  echo "docker run <docker-options> <image> shell-command... -- run a shell command"
  exit 0
fi

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

ENTRYPOINT="/entrypoint-$1"
[ -x "$ENTRYPOINT" ] || ENTRYPOINT="$1"

shift
exec "$ENTRYPOINT" "$@"
