# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vbguest.auto_update = true

  config.vm.define "prod" do |d|
    d.vm.box = "centos/7"
    d.vm.hostname = "prod"
    d.vm.network "private_network" , type: "dhcp"
    d.vm.provision :shell, path: "scripts/passwordAuthentication.sh"
    d.vm.provider "virtualbox" do |v|
      v.memory = 1024
    end
  end


  config.vm.define "fuseAmq" do |d|
    d.vm.box = "centos/7"
    d.vm.hostname = "fuseAmq"
    d.vm.network "private_network" , type: "dhcp"
    d.vm.synced_folder ".", "/vagrant"
    d.vm.provision :shell, path: "scripts/bootstrap_ansible.sh"
    d.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/main.yml -c local"
    d.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end



end
