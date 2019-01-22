# Linux-router
This app allows you to use your Linux computer as Wi-Fi router without losing full system functionality



## Installation

To install application just open Terminal. Now type this commands one-by-one:

```sh
sudo git clone https://github.com/artgonatiacool/Linux-router

cd Linux-router

sudo bash install.sh
```

Now wait a little bit and answer installation questions about ```SSID``` and a ```password``` of the network. 

After installation successful your computer will reboot and you can now use your "router".

## Uninstallation

If you want to uninstall all this stuff just follow this commands:

```sh
sudo apt-get remove hostapd udhcpd

sudo apt-get autoremove
```
