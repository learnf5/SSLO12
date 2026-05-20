# copy archive files from GitHub to bigip1
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/sslo1_5_services.ucs --output /tmp/sslo1_5_services.ucs
sudo scp /tmp/sslo1_5_services.ucs 192.168.1.31:/var/local/ucs

# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# Backup the existing configuration
cp /etc/netplan/01-config.yaml /etc/netplan/01-config.yaml.bak

# Replace the contents with new configuration (update below as needed
cat <<EOF | sudo tee /etc/netplan/01-config.yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens160:
      dhcp4: false
      addresses:
      - 10.10.1.30/16
      - 10.10.1.251/16
      - 10.10.1.252/16
      - 10.10.1.253/16
    ens192:
      dhcp4: false
      addresses:
      - 192.168.1.30/16
      routes:
      - to: default
        via: 192.168.0.254
      nameservers:
        addresses:
        - 8.8.8.8
        - 8.8.4.4
        search:
        - f5trn.com
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
until ping -c 1 ntp.org; do sleep 1; done
