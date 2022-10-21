FROM alpine:latest

RUN apk update && \
    apk add nginx unzip aria2 supervisor && \
    mkdir -p /etc/supervisor.d /downloads /run/nginx && \
    touch /aria2.session && \
    echo -e "dir=/downloads\n\
disk-cache=32M\n\
continue=true\n\
max-concurrent-downloads=10\n\
max-connection-per-server=5\n\
min-split-size=10M\n\
split=10\n\
input-file=/aria2.session\n\
save-session=/aria2.session\n\
save-session-interval=5\n\
enable-rpc=true\n\
rpc-allow-origin-all=true\n\
rpc-listen-all=false\n\
bt-detach-seed-only=true\n\
    " > /etc/aria2.conf && \
    echo -e "[program:aria2]\n\
command=/usr/bin/aria2c --conf-path=/etc/aria2.conf" > /etc/supervisor.d/aria2.ini && \
    echo -e "[program:nginx]\n\
command=/usr/sbin/nginx -g 'daemon off;'" > /etc/supervisor.d/nginx.ini && \
    echo -e 'server {\n\
    listen 80;\n\
    location / {\n\
        root /srv;\n\
        index index.html index.htm;\n\
    }\n\
    location /jsonrpc {\n\
        proxy_pass http://localhost:6800/jsonrpc;\n\
        proxy_redirect off;\n\
        proxy_set_header        X-Real-IP       $remote_addr;\n\
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;\n\
        proxy_set_header Host $host;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "upgrade";\n\
    }\n\
}' > /etc/nginx/http.d/default.conf && \
    wget -O /tmp/ariang.zip https://github.com/mayswind/AriaNg/releases/download/1.2.5/AriaNg-1.2.5-AllInOne.zip && \
    cd /srv && \
    unzip /tmp/ariang.zip index.html && \
    rm /tmp/ariang.zip

CMD /usr/bin/supervisord -nc /etc/supervisord.conf
