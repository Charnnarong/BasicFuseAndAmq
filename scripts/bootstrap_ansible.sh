#!/bin/bash
sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y update
ansible --version
if [ $? == 0 ]; then
	echo "Successfully install Ansible"
else
	echo "Installing Ansible"
	sudo yum -y install ansible
	cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
fi

