# copy archive files from GitHub to bigip1
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/sslo12-base-v12-beta.scf --output /tmp/sslo12-base-v12-beta.scf
sudo scp /tmp/*.scf 192.168.1.31:/var/local/scf

# copy BIG-IP setup script from Github to BIG-IP-01
curl --silent https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/sslo12_bigip_setup_1.0.sh --output /tmp/sslo12_bigip_setup_1.0.sh
sudo scp /tmp/sslo12_bigip_setup_1.0.sh 192.168.1.31:/shared/tmp

### WE MAY NEED TO SAVE THIS FOR THE SECOND OF TWO LABS (TMSH)
# load/merge archive to bigip1 and pause
#sudo ssh 192.168.1.31 tmsh load sys config merge file sslo12-base-v12-beta.scf
#sleep 15

# confirm bigip1 is active
#for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
