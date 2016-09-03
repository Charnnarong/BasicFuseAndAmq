####Project requirements.
+   Vagrant 1.8.5 with the fixed as [demonstrated](http://konecth.blogspot.com.au/2016/08/vagrant-185-default-warning.html)
+   Virtualbox version 5 or newer 
    Because we use Centos/7 vagrant image for this project. There are some problems present, fortunately, we have work around for those.
    +   GuestAdditions Problem: 
        With the latest Centos/7 image at the time of writing (images updated on 28th July 2016).
        <pre>$ vagrant box list
        centos/7                    (virtualbox, 1607.01)</pre>
        
        During vagrant up, GuestAdditions may not install properly, mostly will failed on installing windows driver.
        When this happened, vagrant won't be able to configure private hostname as defined in Vagrantfile as we intended to do so.
        To fixed this, after vagrant up , please proceed with <code>vagrant reload</code>. This will cause Vagrant + Virtualbox respect to Vagrantfile successfully.
