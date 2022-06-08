#!/usr/bin/env bash

out_dir="$1"

mkdir -p "${out_dir}"

openssl req -new -config ./cert.cfg -newkey rsa:4096 -x509 -sha256 -days 730 -nodes -out "${out_dir}/tls.crt" -keyout "${out_dir}/tls.key"
chmod 400 "${out_dir}/tls.key"
