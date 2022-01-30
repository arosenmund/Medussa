#! /bin/bash
#TEMLATE: v3.0 4-17-2020 ironcat
######################################Pluralsight Editing Only#######################################################################################
#timesyncd attempts to reach out to ntp.ubuntu.com but hangs because it gets not response, this will speed up overall loadtime.
systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd

sudo apt update
sudo apt install nmap

