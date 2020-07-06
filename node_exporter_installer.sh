#!/bin/bash


cd /tmp
curl -s  https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep -e 'browser_download_url.*linux-amd64.tar.gz' | awk '{print $2}' | xargs wget
mkdir /opt/node_exporter
tar -xf node_exporter*tar.gz --directory /opt/node_exporter
BIN=`find /opt/node_exporter/*/node_exporter`
cat << EOF > /lib/systemd/system/node_exporter.service
[Unit]
Description=Prometheus agent
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=$BIN

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart node_exporter
