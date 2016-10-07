#!/bin/bash
sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y update
ansible --version
if [ $? == 0 ]; then
    echo "Successfully install Ansible"
else
    sudo yum -y group install "Development Tools"
    sudo yum -y install \
                    git \
                    libtomcrypt \
                    libtommath \
                    libyaml \
                    openssl-devel \
                    pyOpenSSL.x86_64 \
                    python-babel \
                    python-backports \
                    python-backports-ssl_match_hostname \
                    python-cryptography.x86_64 \
                    python-devel.x86_64 \
                    python-httplib2 \
                    python-jinja2 \
                    python-keyczar \
                    python-markupsafe \
                    python-pip \
                    python-pyasn1 \
                    python-setuptools \
                    python-six \
                    python2-crypto \
                    python2-ecdsa \
                    python2-paramiko \
                    PyYAML \
                    sshpass \
                    sshpass.x86_64
    sudo pip install --upgrade pip
    sudo pip install paramiko PyYAML Jinja2 httplib2 six
    if [ ! -d /vagrant/ansible_community ]; then
        sudo rm -rf /vagrant/ansible_community
    fi
    sudo mkdir /vagrant/ansible_community/
    git clone git://github.com/ansible/ansible.git --recursive /vagrant/ansible_community/
    source /vagrant/ansible_community/hacking/env-setup
    cd /vagrant/ansible_community/
    sudo python setup.py build
    sudo python setup.py install
    if [ ! -d /etc/ansible/ ]; then
        sudo rm -rf /etc/ansible
    fi
    sudo mkdir /etc/ansible/

    sudo cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg

fi


