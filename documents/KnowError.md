####Known Error.
* **Not install Virtualbox Guest Additions. The error is looks like**

    ==> default: Checking for guest additions in VM...
        default: No guest additions were detected on the base box for this VM! Guest
        default: additions are required for forwarded ports, shared folders, host only
        default: networking, and more. If SSH fails on this machine, please install
        default: the guest additions and repackage the box to continue.
        default:
        default: This is not an error message; everything may continue to work properly,
        default: in which case you may ignore this message.
    ==> default: Setting hostname...
    ==> default: Configuring and enabling network interfaces...

    **Solution:**
    The box you are running may have to have Virtualbox Guest Additions installed or 
    vagrant may not be able to config the base box properly. If it doesn't , you may have to 
    install an additional plugin ; vagrant-vbguest
    ```ruby
    vagrant plugin install vagrant-vbguest
    ```
    Then ensure that _config.vbguest.auto_update = true_ is set. 
    
* **IP collision**

    If there were too many IP addresses are being use. Resetting those IP could solve the problem.
    
    **Solution:**
        
        ```bash
        ipconfig /release
        ```
    
    
    