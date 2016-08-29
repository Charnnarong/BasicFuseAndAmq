# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vbguest.auto_update = true

  config.vm.define "fuseAmq" do |d|
    d.vm.box = "centos/7"
    d.vm.hostname = "fuseAmq"
    d.vm.network "private_network" , ip: "192.168.50.30"
    d.vm.synced_folder ".", "/vagrant"
    d.vm.provision :shell, path: "scripts/bootstrap_ansible.sh"
    d.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/main.yml -c local"
    d.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end

  config.vm.define "prod-1" do |d|
    d.vm.box = "centos/7"
    d.vm.hostname = "prod-1"
    d.vm.network "private_network", ip: "192.168.50.40"
    d.vm.synced_folder ".", "/vagrant", disabled: true
    d.vm.provision :shell, path: "scripts/passwordAuthentication.sh"
  end

  config.vm.define "prod-2" do |d|
    d.vm.box = "centos/7"
    d.vm.hostname = "prod-2"
    d.vm.network "private_network" , ip: "192.168.50.50"
    d.vm.synced_folder ".", "/vagrant", disabled: true
    d.vm.provision :shell, path: "scripts/passwordAuthentication.sh"
  end

  config.vm.define "prod-3" do |d|
    d.vm.box = "centos/7"
    d.vm.hostname = "prod-3"
    d.vm.network "private_network" , ip: "192.168.50.60"
    d.vm.synced_folder ".", "/vagrant", disabled: true
    d.vm.provision :shell, path: "scripts/passwordAuthentication.sh"
  end

end
