####Description
    // TODO : Automate microservice environment.

####Tested project environment.
+   Vagrant 1.8.5 with the fixed as demonstrate on 
+   Virtualbox 5.0.16 r105871 ( The newer version may not work for installing GuestAdditions on Centos/7 )

####Plausible problemes occured while running the project

* **Setup etcd cluster**
    While running 
    ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/etcd.yml
    etcd cluster may not be able to create cluster successfully after the play.
    Just replay the playbook for a few time and it work. ( TO BE FIX)
        

[Known Errors.](./documents/KnowError.md)

    
    
    
    
