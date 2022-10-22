#!/bin/sh

set -ue

if [ -n ${TZ} ] && [ -e /usr/share/zoneinfo/$TZ ]; then
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
fi

if [ -n ${PUID:-} ]; then
    if ! grep -q aria2 /etc/passwd; then
        adduser -u $PUID -HD -s /bin/false aria2
    fi
    user_conf=$(printf 'user = %s\n' $PUID)
    if ! grep -q "${user_conf}" /etc/supervisor.d/aria2.ini; then
        printf "${user_conf}" >>/etc/supervisor.d/aria2.ini
    fi
fi

exec /usr/bin/supervisord -nc /etc/supervisord.conf
