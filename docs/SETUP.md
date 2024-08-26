# Timescale

## Installation

### Timescale

https://docs.timescale.com/timescaledb/latest/how-to-guides/install-timescaledb/self-hosted/debian/installation-apt-debian/
```
chmod 644 keyring
```

File /etc/postgresql/13/main/conf.d/ovh.conf
```
data_directory = '/home/postgresql'
listen_addresses = '*'
max_connections = 1000
log_connections = 'on'
```

File /etc/postgresql/13/main/conf.d/timescale.conf
```
max_prepared_transactions = 150
enable_partitionwise_aggregate = on
jit = off
statement_timeout = 0
timescaledb.passfile = '/var/lib/postgresql/.pgpass'
wal_level = 'logical'
```

chown postgres: /etc/postgresql/13/main/conf.d/ovh.conf /etc/postgresql/13/main/conf.d/timescale.conf

File /etc/postgresql/13/main/pg_hba.conf
```
local       all         postgres                                peer
local       all         all                                     md5
hostnossl   all         all             all                     reject
hostssl     all         all             all                     md5
```

mkdir /home/postgresql
chown postgres: /home/postgresql
su - postgres -c "/usr/lib/postgresql/13/bin/initdb --data-checksums /home/postgresql"

systemctl start postgresql

### Promscale extension

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > install.sh
vim install.sh
mkdir /home/rust
sh install.sh
source $HOME/.cargo/env
TMPDIR=/home/rust cargo install --git https://github.com/JLockerman/pgx.git --branch timescale cargo-pgx
cargo pgx init --pg13=/usr/lib/postgresql/13/bin/pg_config
curl -L -o "promscale_extension.zip" "https://github.com/timescale/promscale_extension/archive/refs/tags/0.2.0.zip"
apt-get install unzip
unzip promscale_extension.zip
cd promscale_extension-0.2.0
make
make install
```

### Promscale

```
wget https://github.com/timescale/promscale/releases/download/0.6.2/promscale_0.6.2_Linux_x86_64.deb
dpkg -i promscale_0.6.2_Linux_x86_64.deb
```


# Configuration

## Timescale

### Data node

```
su - postgres
read -s PASSWORD
psql -c "create user timescale with password '${PASSWORD}' superuser;"
psql -c "create database timescale owner timescale;"
psql -c "create extension timescaledb;" timescale
```

### Access node

```
su - postgres
read -s PASSWORD
echo "*:*:*:timescale:${PASSWORD}" > /var/lib/postgresql/.pgpass
chmod 600 /var/lib/postgresql/.pgpass
psql -c "create user timescale with password '${PASSWORD}' superuser;"
psql -c "create database timescale owner timescale;"
psql -c "create extension timescaledb;" timescale
psql -U timescale -c "select add_data_node(node_name => 'timescale-002', host => '***OBFUSCATED***');" timescale
```

### Both

File /etc/iptables.d/12-postgresql.rules.ipv4

```
* filter
-N POSTGRES

-A INPUT  -p tcp -j POSTGRES -m comment --comment "postgresql" --dport 5432
-A POSTGRES  -j ACCEPT -m comment --comment "timescale-001" -s ***OBFUSCATED***
-A POSTGRES  -j ACCEPT -m comment --comment "timescale-002" -s ***OBFUSCATED***
-A POSTGRES  -j ACCEPT -m comment --comment "timescale-003" -s ***OBFUSCATED***

COMMIT
```

## Promscale

File /etc/promscale.conf:
```
PROMSCALE_DB_CONNECTIONS_MAX="8"
PROMSCALE_DB_HOST="127.0.0.1"
PROMSCALE_DB_NAME="timescale"
PROMSCALE_DB_PASSWORD="***OBFUSCATED***"
PROMSCALE_DB_PORT="5432"
PROMSCALE_DB_SSL_MODE="require"
PROMSCALE_DB_USER="timescale"
PROMSCALE_DB_WRITER_CONNECTION_CONCURRENCY="4"
PROMSCALE_INSTALL_EXTENSIONS="true"
```

Then start service:
```
systemctl start promscale.service
systemctl enable promscale.service
```

## Node exporter

```
apt-get -y install prometheus-node-exporter
systemctl start prometheus-node-exporter
systemctl enable prometheus-node-exporter
```

## Grafana agent

```
curl -O -L "https://github.com/grafana/agent/releases/download/v0.19.0/agent-linux-amd64.zip"
unzip "agent-linux-amd64.zip"
chmod a+x "agent-linux-amd64"
mv agent-linux-amd64 /usr/local/bin/grafana-agent
useradd -s /usr/sbin/nologin -r -M grafana-agent
```

File /etc/systemd/system/grafana-agent.service
```
[Unit]
Description=Grafana Agent

[Service]
Type=simple
User=grafana-agent
ExecStart=/usr/local/bin/grafana-agent -prometheus.wal-directory=/home/grafana-agent/wal -config.file=/etc/grafana-agent.yml
Restart=always

[Install]
WantedBy=multi-user.target
```

Reload
```
systemctl daemon-reload
```

Create directories:
```
mkdir /home/grafana-agent
chown grafana-agent: /home/grafana-agent
```

File /etc/grafana-agent.yml:

```
server:
  log_level: debug
  http_listen_port: 12345

prometheus:
  global:
    # purposedly increase the frequency to assess the resource consumption
    scrape_interval: 10s
  configs:
    - name: test
      host_filter: false
      scrape_configs:
        - job_name: node_exporter
          static_configs:
            - targets: ['localhost:9100']
        - job_name: grafana_agent
          static_configs:
            - targets: ['localhost:12345']
      remote_write:
        - url: http://127.0.0.1:9201/write
```

Start service:
```
systemctl enable grafana-agent
systemctl start grafana-agent
```
