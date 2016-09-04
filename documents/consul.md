####Sample Service Discovery ( Consul )

   At the end of the play, we will have infrastructure similar to [etcd demo](etcd.md). Only replaced etcd with consul.
   
   Steps to run consul demo is quite a bit simpler than etcd since we embrace most tasks into a single playbook.
   
   Please follow step 1 to 4 from etcd demonstration page. Then come back to continue with the rest from here. 
      
   1. [vagrant@fuseAmq ~]$ <code>ansible-playbook -i /vagrant/ansible/hosts/serv-disc /vagrant/ansible/consul.yml</code>
        
       At the end of the play book, you should see the log show similar to this.
       
       <pre>PLAY RECAP *********************************************************************
       prod-1                     : ok=27   changed=14   unreachable=0    failed=0
       prod-2                     : ok=32   changed=23   unreachable=0    failed=0
       prod-3                     : ok=32   changed=23   unreachable=0    failed=0</pre>
       
       
       
   2. [vagrant@prod-2 ~]$ <code>docker run -d --name nginx --env SERVICE_NAME=nginx --env SERVICE_ID=nginx -p 1234:80 nginx</code>
   
   3. [vagrant@prod-3 ~]$ <code>docker run -d --name nginx2 --env SERVICE_NAME=nginx --env SERVICE_ID=nginx2 -p 1234:80 nginx</code>
      
      Your project environment state is show as the following diagram.
      <br/>
                  
      ![Imgur](http://i.imgur.com/5sFr3wl.png)
      <br/>
       
      Now you can play with consule by query information of nigix we just has run.
      
      [vagrant@fuseAmq ~]$ <code>curl http://10.100.193.20:8500/v1/catalog/service/nginx-80 | jq '.'</code>
      
      and 
      
      <pre>
       [vagrant@prod-1 ~]$ /usr/local/bin/consul-template -consul localhost:8500 -template "/tmp/sample_nginx_tempalte.ctmpl:/tmp/nginx.conf" -once
       [vagrant@prod-1 ~]$ cat /tmp/nginx.conf
       
       The address is 10.100.193.20:1234
       
       The address is 10.100.193.30:1234
       
       [vagrant@prod-1 ~]$</pre>
       
       From your favourite browser, you can see consul UI with <a>http://10.100.193.10:8500</a>
       
       <br/>
       
       ![Imgur](http://i.imgur.com/Urfi6gP.png)
       <br/>
   
      
   Congratulation. Well done!
   