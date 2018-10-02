#!/usr/bin/env bash

export HOST_IP_ADDR=127.0.0.1

curl -i -X POST http://localhost:8001/services/ \
  -d "name=kong-springboot" \
  -d "protocol=http" \
  -d "host=${HOST_IP_ADDR}" \
  -d "port=8080"

curl -i -X POST http://localhost:8001/services/ \
  -d "name=kong-springboot2" \
  -d "protocol=http" \
  -d "host=${HOST_IP_ADDR}" \
  -d "port=8090"

curl -i -X POST http://localhost:8001/services/kong-springboot/routes/ \
  -d "protocols[]=http" \
  -d "hosts[]=kong-springboot" \
  -d "paths[]=/api/public" \
  -d "strip_path=false"

PRIVATE_ROUTE_ID=$(curl -s -X POST http://localhost:8001/services/kong-springboot/routes/ \
  -H 'Content-Type: application/json' \
  -d '{ "protocols": ["http"], "hosts": ["kong-springboot"], "paths": ["/api/private"], "strip_path": false }' | jq -r .id)

#curl -i -X POST http://localhost:8001/services/kong-springboot2/routes/ \
#  -d "protocols[]=http" \
#  -d "hosts[]=kong-springboot2" \
#  -d "paths[]=/api/order" \
#  -d "strip_path=false"

curl -i -X POST http://localhost:8001/services/kong-springboot2/routes/ \
  -d "protocols[]=http" \
  -d "paths[]=/api/order" \
  -d "strip_path=false"

curl -X POST http://localhost:8001/routes/${PRIVATE_ROUTE_ID}/plugins \
  -d "name=basic-auth" \
  -d "config.hide_credentials=true"

curl -X POST http://localhost:8001/consumers \
  -d "username=user_polaristech"

curl -X POST http://localhost:8001/consumers/user_polaristech/basic-auth \
  -d "username=polaristech" \
  -d "password=123"

curl -i http://localhost:8000/api/public -H 'Host: kong-springboot'

curl -i -u polaristech:123 http://localhost:8000/api/private -H 'Host: kong-springboot'
