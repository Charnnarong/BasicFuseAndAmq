####Sample Service Discovery ( Consul )

   At the end of the play, we will have infrastructure as shown
   <br/>
   ![Fianl](http://i.imgur.com/eEJgTmd.png)
   <br/>
   
   From the diagram above. Say you deploy any container inside any docker engine among prod-1 , prod-2 or prod-3.
   You can discover what the ip or port is.
   
   <br/>
   
   1. $ <code>git clone https://github.com/Charnnarong/BasicFuseAndAmq.git</code>
   2. $ <code>cd BasicFuseAndAmq</code>
   3. $ <code>vagrant up</code>
   
       <pre>Bringing machine 'fuseAmq' up with 'virtualbox' provider...
        Bringing machine 'prod-1' up with 'virtualbox' provider...
        Bringing machine 'prod-2' up with 'virtualbox' provider...
        Bringing machine 'prod-3' up with 'virtualbox' provider...
        ==> fuseAmq: Importing base box 'centos/7'...
        ...
        ...skip...
        ...
        ==> prod-3: Checking PasswordAuthentication permission
        ==> prod-3: Enabliing password authentication.</pre>
   
       *Remark, if your vagrant doesn't have vagrant-vbguest install. The project will try to install it automatically.
       However, once it install, to log will still showing an error. This is not a problem. You just need to run <code>vagrant up</code> again it should run the rest of the Vagrant file successfully.
       
      Now you will have 
      
      <br/>
      
      ![Imgur](http://i.imgur.com/bzRnwMD.png)
      
      <br/>
      
   4. $ <code>vagrant ssh fuseAmq</code>
  
       Now you will need to check if vagrant is able to set up private network correctly.
        If eth1 is 10.100.192.10 then you are good to go.
       <pre>[vagrant@fuseAmq ~]$ ip route show
        default via 10.0.2.2 dev eth0  proto static  metric 100
        10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15  metric 100
        10.100.192.0/24 dev eth1  proto kernel  scope link  src 10.100.192.10
        169.254.0.0/16 dev eth1  scope link  metric 1003
        172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.0.1</pre>

       Similarly to prod-1 , prod-2 and prod-3 you should see something like this for prod-2
       <pre>[vagrant@prod-2 ~]$ ip route show
        default via 10.0.2.2 dev eth0  proto static  metric 100
        10.0.2.0/24 dev eth0  proto kernel  scope link  src 10.0.2.15  metric 100
        10.100.193.0/24 dev eth1  proto kernel  scope link  src 10.100.193.20
        169.254.0.0/16 dev eth1  scope link  metric 1003</pre>
  
       Before running any other ansible play book, you should verify if we could reach all nodes with Ansible.
       
       <pre>[vagrant@fuseAmq ~]$ ansible -i /vagrant/ansible/hosts/serv-disc -m ping all
       prod-2 | SUCCESS => {
           "changed": false,
           "ping": "pong"
       }
       prod-3 | SUCCESS => {
           "changed": false,
           "ping": "pong"
       }
       prod-1 | SUCCESS => {
           "changed": false,
           "ping": "pong"
       }</pre>
       
       Well done. Everything is set. Let's move on.
       
   5. [vagrant@fuseAmq ~]$ <code>ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/etcd.yml</code>
        
       <pre>PLAY RECAP *********************************************************************
       prod-1                     : ok=10   changed=6    unreachable=0    failed=0
       prod-2                     : ok=10   changed=6    unreachable=0    failed=0
       prod-3                     : ok=10   changed=6    unreachable=0    failed=0</pre>
       Once that is done without any error. Your diagram is now updated to
       <br/>
       
       ![Imgur](http://i.imgur.com/ALaXqDT.png)
       <br/>
       
       _Important_ You should verify manually if etcd is running properly by grep process of etcd for each prod-x node
       <pre>[vagrant@prod-1 ~]$  ps -A | grep etcd
        15183 ?        00:00:00 etcd
        
        [vagrant@prod-2 ~]$ ps -A | grep etcd
        14494 ?        00:00:04 etcd
        
        [vagrant@prod-3 ~]$  ps -A | grep etcd
        14468 ?        00:00:02 etcd</pre>
       
       If any one of nodes can not start etcd. You can re-run the playbook one more time or two. 
       ( I am not sure how this problem occasionally occurred. But I am assuming that it is all about ssh problem or delay to start. **Any idea ?** if you were lucky to see it occurred)
       
       To test etcd cluster functionality. We will try to put some key/value to prod-1 and query the result from prod-2 and prod-3. Then we should be able to see results no matter which node we are querying to.
       <pre>[vagrant@fuseAmq ~]$ curl http://10.100.193.10:2379/v2/keys/hello -X PUT -d value="world" | jq '.'
         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
       100   105  100    94  100    11  17675   2068 --:--:-- --:--:-- --:--:-- 18800
       {
         "action": "set",
         "node": {
           "key": "/hello",
           "value": "world",
           "modifiedIndex": 12,
           "createdIndex": 12
         }
       }
       [vagrant@fuseAmq ~]$ curl http://10.100.193.20:2379/v2/keys/hello | jq '.'
         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
       100    94  100    94    0     0   2791      0 --:--:-- --:--:-- --:--:--  2848
       {
         "action": "get",
         "node": {
           "key": "/hello",
           "value": "world",
           "modifiedIndex": 12,
           "createdIndex": 12
         }
       }
       [vagrant@fuseAmq ~]$ curl http://10.100.193.30:2379/v2/keys/hello | jq '.'
         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
       100    94  100    94    0     0  30089      0 --:--:-- --:--:-- --:--:-- 47000
       {
         "action": "get",
         "node": {
           "key": "/hello",
           "value": "world",
           "modifiedIndex": 12,
           "createdIndex": 12
         }
       }</pre>
       
   6. [vagrant@fuseAmq ~]$ <code>ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/dockerengine.yml --extra-vars "hosts=etcd-cluster"</code>
   
       This play is simple and you can tell right away that it just install docker engine. 
       Now your diagram becomes
       <br/>
              
       ![Imgur](http://i.imgur.com/3hQjRZn.png)
       <br/>
              
   7.  [vagrant@fuseAmq ~]$ <code>ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/registrator.yml --extra-vars "hosts=etcd-cluster"</code>
        
       After this playbook, yours diagram state is
       
       <br/>
                     
       ![Imgur](http://i.imgur.com/yCf4bSZ.png)
       <br/>
       
       With that configure setup. Now you are able to start any docker container and let Registrator automatically register that new container to etcd, but only with a minor change on how to run the container.
       Take nginx for instance. 
       For the sake of simplicity, we will not open docker daemon for now. So for this time, we will temporary  have to log in to prod-3 and run docker.
       
       [vagrant@prod-3 ~]$ <code>exit</code>
       
       You have to exit this because the shell is not refresh afer docker-engine was installed via ansible.
       
       <code>$ vagrant ssh prod-3</code>
       <pre>[vagrant@prod-3 ~]$ docker ps
            CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS              PORTS               NAMES
            0a150a65caad        gliderlabs/registrator   "/bin/registrator -ip"   23 minutes ago      Up 23 minutes                           registrator</pre>
       
       [vagrant@prod-3 ~]$ <code>docker run -d --name nginx --env SERVICE_NAME=nginx --env SERVICE_ID=nginx -p 1234:80 nginx</code>
       
       After nginx started, something must happened inside registrator. To see what's changed 
       [vagrant@prod-3 ~]$ <code>docker logs registrator</code>
       
       To check if the etcd cluster is indeed updated. We can query for keys from any node , take prod-1 for instance.
       [vagrant@fuseAmq ~]$ <code>curl http://10.100.193.10:2379/v2/keys/ | jq '.'</code>
       
       <pre>[vagrant@fuseAmq ~]$ curl http://10.100.193.10:2379/v2/keys/nginx-80 | jq '.'
         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
       100   194  100   194    0     0  65385      0 --:--:-- --:--:-- --:--:-- 97000
       {
         "action": "get",
         "node": {
           "key": "/nginx-80",
           "dir": true,
           "nodes": [
             {
               "key": "/nginx-80/nginx",
               "value": "10.100.193.30:1234",
               "modifiedIndex": 13,
               "createdIndex": 13
             }
           ],
           "modifiedIndex": 13,
           "createdIndex": 13
         }
       }
       [vagrant@fuseAmq ~]$ curl http://10.100.193.10:2379/v2/keys/nginx-80/nginx | jq '.'
         % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                        Dload  Upload   Total   Spent    Left  Speed
       100   116  100   116    0     0  38309      0 --:--:-- --:--:-- --:--:-- 58000
       {
         "action": "get",
         "node": {
           "key": "/nginx-80/nginx",
           "value": "10.100.193.30:1234",
           "modifiedIndex": 13,
           "createdIndex": 13
         }
       }</pre>
       
       Check out our nginx container on  http://10.100.193.30:1234
   
   8. [vagrant@fuseAmq ~]$ <code>ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/confd.yml</code>
   
      Finally after this playbook, you will get our final result.
      <br/>
            
      ![Fianl](http://i.imgur.com/eEJgTmd.png)
      <br/>
      
      To check if confd is able to read key/value form etcd. Try the following command.
      <pre>[vagrant@prod-2 ~]$ confd -onetime -backend etcd -node http://127.0.0.1:2379
      2016-09-03T07:13:00Z prod-2 confd[16413]: INFO Backend set to etcd
      2016-09-03T07:13:00Z prod-2 confd[16413]: INFO Starting confd
      2016-09-03T07:13:00Z prod-2 confd[16413]: INFO Backend nodes set to http://127.0.0.1:2379
      2016-09-03T07:13:00Z prod-2 confd[16413]: ERROR 100: Key not found (/nginxB-80) [13]
      2016-09-03T07:13:00Z prod-2 confd[16413]: FATAL 100: Key not found (/nginxB-80) [13]</pre>
      
      That is because we haven't have nginxB-80 yet. To make that available. We can spin up another nginx like so
      <pre>[vagrant@prod-1 ~]$ exit
       
       vagrant ssh prod-1
       
       [vagrant@prod-1 ~]$ docker run -d --name nginx --env SERVICE_NAME=nginxB --env SERVICE_ID=nginxB -p 1234:80 nginx</pre>
      
      Once that done confd will now successfully parse all key and update to tmp/sample.conf 
      
      <pre>[vagrant@prod-2 ~]$ confd -onetime -backend etcd -node http://127.0.0.1:2379
      2016-09-03T07:27:55Z prod-2 confd[16418]: INFO Backend set to etcd
      2016-09-03T07:27:55Z prod-2 confd[16418]: INFO Starting confd
      2016-09-03T07:27:55Z prod-2 confd[16418]: INFO Backend nodes set to http://127.0.0.1:2379
      2016-09-03T07:27:55Z prod-2 confd[16418]: INFO Target config /tmp/sample.conf out of sync
      2016-09-03T07:27:55Z prod-2 confd[16418]: INFO Target config /tmp/sample.conf has been updated
      
      [vagrant@prod-2 ~]$ cat /tmp/sample.conf
      The address nginx is 10.100.193.30:1234
      The address nginxB is 10.100.193.10:1234</pre>
      
   Congratulation. Well done!
   