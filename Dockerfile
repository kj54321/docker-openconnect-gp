FROM alpine:latest
MAINTAINER Donny Jie <dong115@uwindsor.ca>
LABEL version="0.1"
LABEL description="Openconnect for gp in docker"

RUN set -ex \
# 1. add test repo, fix nsswitch error
    && echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && echo 'hosts: files dns' >> /etc/nsswitch.conf \
    && apk --update --no-progress upgrade \
    && apk add --no-progress stoken-dev@testing \
# 2. build and install openconnect (fork from: https://github.com/gzm55/docker-vpn-client)
## 2.1 install runtime and build dependencies
    && apk add --no-progress --virtual .openconnect-run-deps \
               gnutls gnutls-utils iptables libev libintl \
               libnl3 libseccomp linux-pam lz4-libs openssl \
               libxml2 openssh-client libproxy libtool stoken@testing krb5 \
    && apk add --no-progress --virtual .openconnect-build-deps \
               unzip curl file g++ gnutls-dev gpgme gzip libev-dev build-base \
               libnl3-dev libseccomp-dev libxml2-dev linux-headers \
               linux-pam-dev lz4-dev make readline-dev tar \
               sed readline procps gettext autoconf automake libproxy-dev krb5-dev \
## 2.2 download vpnc-script
    && mkdir -p /etc/vpnc \
    && curl -s http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script -o /etc/vpnc/vpnc-script \
    && chmod 750 /etc/vpnc/vpnc-script \
## 2.3 create build dir, download, verify and decompress OC package to build dir
    && curl -k -sSL "https://github.com/dlenski/openconnect/archive/globalprotect.zip" -o /tmp/globalprotect.zip \
    && unzip -qq /tmp/globalprotect.zip -d /tmp \
## 2.4 build and install
    && cd /tmp/openconnect-globalprotect \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
# 3. cleanup
    && apk del .openconnect-build-deps \
    && rm -rf /var/cache/apk/* /tmp/* \
    && apk del stoken-dev

COPY content /

ENTRYPOINT ["/entrypoint.sh"]
