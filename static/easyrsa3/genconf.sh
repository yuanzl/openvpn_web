#!/bin/bash

username=$1
capass="123456"
pwd=$(dirname $0)
cd $pwd

vpnconf1="client
dev tun
proto tcp-client
remote myvpn.org 1194

allow-recursive-routing

resolv-retry infinite
nobind
persist-key
persist-tun
"

vpnconf2="
tls-auth ta.key 1

remote-cert-tls server
auth-user-pass
auth-nocache

cipher AES-256-CBC

comp-lzo
compress 'lz4'
verb 3
mute 20
"

[ -f "pki/issued/${username}.crt" ] && rm -f pki/issued/${username}.crt
[ -f "pki/private/${username}.key" ] && rm -f pki/private/${username}.key
[ -f "pki/reqs/${username}.req" ] && rm -f pki/reqs/${username}.req


/usr/bin/expect <<-EOF
spawn ./easyrsa build-client-full $username nopass
expect {
   "*ca.key:" {
      send "${capass}\r"
   }
}
expect eof
EOF

[ ! -f "pki/issued/${username}.crt" ] &&  exit -1

CA=$(cat pki/ca.crt)
CERT=$(cat pki/issued/${username}.crt)
KEY=$(cat pki/private/${username}.key)

echo -e "${vpnconf1}\n<ca>\n"${CA}"\n</ca>\n<cert>\n"${CERT}"\n</cert>\n<key>\n"${KEY}"\n</key>${vpnconf2}" > $username.ovpn

rm -f pki/issued/${username}.crt
rm -f pki/private/${username}.key
rm -f pki/reqs/${username}.req
rm -f pki/certs_by_serial/*.pem
