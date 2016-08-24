#!/usr/bin/env bash
echo "Checking PasswordAuthentication permission"
redhatDistribution=`ls /etc/*release | grep -E "centos|redhat" | wc -l`
if [ $redhatDistribution -gt 0 ]; then
        echo "Enabliing password authentication."
        sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/g' /etc/ssh/sshd_config
        sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        sudo systemctl restart  sshd.service
else
        echo "Your OS is not Redhat or Centos distribution. This may not require password authentication enable."
fi