#!/bin/sh

set -ue

if [ -n ${TZ} && -e /usr/share/zoneinfo/$TZ ]; then
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
fi

if [ -n ${PUID:-} ]; then
    adduser -u $PUID -HD -s /bin/false aria2
    printf 'user = %s\n' $PUID >>/etc/supervisor.d/aria2.ini
fi

exec /usr/bin/supervisord -nc /etc/supervisord.conf
