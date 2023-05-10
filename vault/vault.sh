#!/bin/bash

# Create Vault configuration file
sudo mkdir /etc/vault
sudo cat <<EOF > /etc/vault/config.hcl
storage "file" {
  path = "/var/lib/vault/data"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}
EOF

# Create Vault service file
sudo cat <<EOF > /etc/systemd/system/vault.service
[Unit]
Description=Vault service
Requires=network-online.target
After=network-online.target

[Service]
User=vault
Group=vault
ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl
ExecReload=/usr/local/bin/kill --signal HUP \$MAINPID
KillSignal=SIGTERM
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Create Vault user and directories
sudo useradd --system --home /etc/vault --shell /bin/false vault
sudo mkdir --parents /var/lib/vault/data
sudo chown --recursive vault:vault /etc/vault /var/lib/vault

# Enable and start Vault service
sudo systemctl enable vault.service
sudo systemctl start vault.service
