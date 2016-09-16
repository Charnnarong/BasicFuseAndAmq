#!/bin/bash
sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y update
ansible --version
if [ $? == 0 ]; then
	echo "Successfully install Ansible"
else
	echo "Installing Ansible"
#	sudo yum -y install ansible
    sudo yum -y install git
    sudo git clone git://github.com/ansible/ansible.git --recursive
    cd ansible
    sudo yum -y groupinstall 'development tools'
    sudo yum -y install python-pip
    sudo yum -y install python-devel
    sudo yum -y install gcc libffi-devel python-devel openssl-devel
    sudo yum -y install sshpass asciidoc
    sudo pip install -U distribute
    sudo pip install paramiko PyYAML Jinja2 httplib2 six
    sudo yum -y install PyYAML libtomcrypt libtommath libyaml python-babel python-httplib2 python-jinja2 python-keyczar python-markupsafe python-pyasn1 python-six python2-crypto python2-ecdsa python2-paramiko
    sudo make rpm
    sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm

	cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
fi


#Installing:
# ansible
#Installing for dependencies:
# PyYAML
# libtomcrypt
# libtommath
# libyaml
# python-babel
# python-httplib2
# python-jinja2
# python-keyczar
# python-markupsafe
# python-pyasn1
# python-six
# python2-crypto
# python2-ecdsa
# python2-paramiko