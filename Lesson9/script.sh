#!/bin/bash
#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#Task1
# Create conf
cat <<EOF > /etc/default/watchlog
# Configuration file for my watchlog service
# Place it to /etc/default

# File and word in that file that we will monitor
WORD="OtusLesson9"
LOG=/var/log/watchlog.log
EOF

# Create logfile
cat <<EOF > /var/log/watchlog.log
OtusLesson9
EOF

# Create sh
cat <<EOF > /opt/watchlog.sh

WORD=\$1
LOG=\$2
DATE=\$(date)

if grep \$WORD \$LOG &> /dev/null
then
    logger "\$DATE: I found word, Master!"
else
    exit 0
fi
EOF

chmod +x /opt/watchlog.sh

# Create service
cat <<EOF > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/default/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
EOF

# Create timer
cat <<EOF > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 seconds

[Timer]
# Run every 30 seconds
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable watchlog.timer
systemctl start watchlog.timer
systemctl start watchlog.service

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
#Task2
apt update
apt install -y spawn-fcgi php php-cgi php-cli apache2 libapache2-mod-fcgid

# Create conf
mkdir -p /etc/spawn-fcgi
cat > /etc/spawn-fcgi/fcgi.conf <<'EOF'
SOCKET=/var/run/php-fcgi.sock
PIDFILE=/var/run/spawn-fcgi.pid
OPTIONS="-u www-data -g www-data -s $SOCKET -S -M 0600 -C 32 -F 1 -P $PIDFILE -- /usr/bin/php-cgi"
EOF

# Create sh
cat > /usr/local/bin/spawn-fcgi-wrapper.sh <<'EOF'
#!/bin/bash
source /etc/spawn-fcgi/fcgi.conf
exec /usr/bin/spawn-fcgi $OPTIONS
EOF
chmod +x /usr/local/bin/spawn-fcgi-wrapper.sh

# Create service
cat > /etc/systemd/system/spawn-fcgi.service <<'EOF'
[Unit]
Description=Spawn FCGI Service
After=network.target

[Service]
Type=forking
PIDFile=/var/run/spawn-fcgi.pid
ExecStart=/usr/local/bin/spawn-fcgi-wrapper.sh
User=root
Group=root
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable spawn-fcgi.service
systemctl start spawn-fcgi.service

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
# Task3
apt install nginx -y

# Create unit
cat <<EOF > /etc/systemd/system/nginx@.service
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx-%I.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-%I.conf -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx-%I.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
EOF

# Create directories for sites
mkdir -p /etc/nginx/sites-enabled/first
mkdir -p /etc/nginx/sites-enabled/second

# Create first conf
cat <<EOF > /etc/nginx/nginx-first.conf
user www-data;
worker_processes auto;
pid /run/nginx-first.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    # server_tokens off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/first/*;

    server {
        listen 9001;
        server_name localhost;

        location / {
            root /var/www/html;
            index index.html index.htm;
        }
    }
}
EOF

# Create second conf
cat <<EOF > /etc/nginx/nginx-second.conf
user www-data;
worker_processes auto;
pid /run/nginx-second.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    # server_tokens off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/second/*;

    server {
        listen 9002;
        server_name localhost;

        location / {
            root /var/www/html;
            index index.html index.htm;
        }
    }
}
EOF


systemctl daemon-reload

systemctl enable nginx@first
systemctl enable nginx@second

systemctl start nginx@first
systemctl start nginx@second

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------