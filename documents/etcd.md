* **Setup etcd cluster**
    While running 
     ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/etcd.yml
                                                                           etcd cluster may not be able to create cluster successfully after the play.
                                                                           Just replay the playbook for a few time and it work. ( TO BE FIX)