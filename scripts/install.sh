#!bin/bash

set -x

ip=$(ip a | grep 192 | awk '{ print $2}' | cut -c -15)

# installing Jenkins Ubuntu/Debian
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

sudo apt-get update
sudo apt-get install -y openjdk-8-jdk 
sudo apt install -y jenkins
sudo apt autoremove -y
sudo systemctl status jenkins --no-pager | grep Active
echo
echo "Jenkins will run on port 8080 usually."
echo "Access Jenkins at http://${ip}:8080"
echo "***********************************"
echo "Username is admin and password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "***********************************"

set +x