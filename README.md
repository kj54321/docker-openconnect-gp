# docker-openconnect-gp 

Openconnect globalprotect in docker. Support openconect with 2FA/OTP, GSAPI, proxy.

[Fork and rewrite](https://github.com/gzm55/docker-vpn-client)

Build:
```
    docker build https://github.com/kj54321/docker-openconnect-gp
```
Or:
```
    git clone https://github.com/kj54321/docker-openconnect-gp
    cd docker-openconnect-gp && ./build.sh
```

Run it in bash like this:

```Bash

#view openconnect help
docker run -it --rm kj54321/docker-openconnect-gp openconect --help

# start a openconnect tunnel

VPN_OPENCONNECT_COOKIE=yyy
docker run --net=host \
           --privileged=true \
           --device=/dev/net/tun \
           --cap-add=NET_ADMIN \
           --name openconnect-tunnel-$VPN_SERVER \
           -e VPN_DEBUG="$VPN_DEBUG" \
           --env-file <(cat <<-END
		VPN_PASSWORD=$VPN_PASSOWRD
		VPN_OPENCONNECT_COOKIE=$VPN_OPENCONNECT_COOKIE
		END
           ) \
           --detach \
           kj54321/docker-openconnect-gp openconnect [<openconnect-options>] <server-domain-or-ip>
```

Accepted docker environment variables for vpn client:

* VPN_DEBUG: no empty string will enable debug option for pppd
* VPN_PASSOWRD: login password
* VPN_OPENCONNECT_COOKIE: login cookie
