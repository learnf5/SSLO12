# copy ca-cert files to internal client
mkdir /home/student/Downloads/certs
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/certs/RootCertAndKey.pfx --output Downloads/certs/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/certs/ca-f5trn-com.crt --output Downloads/certs/ca-f5trn-com.crt
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/certs/ca-f5trn-com.key --output Downloads/certs/ca-f5trn-com.key

#install ca-cert on Internal Client
sudo cp Downloads/certs/ca-f5trn-com.crt /usr/local/share/ca-certificates
sudo update-ca-certificates

#install certutil libnss3-tools
sudo apt update && sudo apt install libnss3-tools -y

#install ca-cert into browsers
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "ca-f5trn-com" -i Downloads/certs/ca-f5trn-com.crt
export FF_PROFILE=$(ls -d ~/snap/firefox/common/.mozilla/firefox/*.default)
certutil -A -n "ca-f5trn-com" -t "TC,," -i Downloads/certs/ca-f5trn-com.crt -d sql:$FF_PROFILE

# Backup the existing configuration
sudo cp /etc/netplan/01-config.yaml /etc/netplan/01-config.yaml.bak

# Replace the contents with new configuration (update below as needed
cat <<EOF | sudo tee /etc/netplan/01-config.yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens160:
      dhcp4: false
      addresses:
      - 172.16.1.30/16
      routes:
      - to: default
        via: 172.16.1.33/16
      nameservers:
        addresses:
        - 8.8.8.8
        - 8.8.4.4
        search:
        - f5trn.com
    ens192:
      dhcp4: false
      addresses:
      - 192.168.1.30/16
    ens32:
      dhcp4: true
      nameservers:
        addresses:
        - 192.168.1.1
        search:
        - shellnet.lods
EOF

# Test and apply the configuration
#sudo netplan try
sudo netplan apply

sleep 2

# confirm networking is up
until ping -c 1 172.16.1.33; do sleep 1; done
