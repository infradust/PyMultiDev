#!/usr/bin/env bash

out_dir="$1"
mkdir -p "${out_dir}/ca" "${out_dir}/client" "${out_dir}/server"

# Certification Authority certificate
echo "creating CA"
openssl genrsa -aes256 -out "${out_dir}/ca/ca.key" 4096
chmod 400 "${out_dir}/ca/ca.key"
openssl req -new -config ./cert.cfg -x509 -sha256 -days 730 -key "${out_dir}/ca/ca.key" -out "${out_dir}/ca/ca.crt"
chmod 444 "${out_dir}/ca/ca.crt"

# The Certificate Signing Request (CSR)
echo "creating SERVER - CSR"
openssl genrsa -out "${out_dir}/server/tls.key" 2048
chmod 400 "${out_dir}/server/tls.key"
openssl req -new -config ./cert.cfg -key "${out_dir}/server/tls.key" -sha256 -out "${out_dir}/server/tls.csr"


# The server certificate
echo "creating SERVER - CRT"
openssl x509 -req -days 365 -sha256 -in "${out_dir}/server/tls.csr" -CA "${out_dir}/ca/ca.crt" -CAkey "${out_dir}/ca/ca.key" -set_serial 1 -out "${out_dir}/server/tls.crt"

# The client certificate
echo "creating CLIENT"
openssl genrsa -out "${out_dir}/client/tls.key" 2048
openssl req -new -config ./cert.cfg -key "${out_dir}/client/tls.key" -out "${out_dir}/client/tls.csr"
openssl x509 -req -days 365 -sha256 -in "${out_dir}/client/tls.csr" -CA "${out_dir}/ca/ca.crt" -CAkey "${out_dir}/ca/ca.key" -set_serial 2 -out "${out_dir}/client/tls.crt"
openssl pkcs12 -export -clcerts -in "${out_dir}/client/tls.crt" -inkey "${out_dir}/client/tls.key" -out "${out_dir}/client/tls.p12"
