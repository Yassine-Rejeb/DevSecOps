#!/bin/bash

sudo cat <<EOF > $HOME/devsecops/vault/volumes/config/config.hcl
storage "file" {
  path    = "/vault/file"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = "true"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true
EOF

cd $HOME/devsecops/vault
docker-compose up