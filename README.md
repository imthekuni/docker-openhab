Overview
========

Docker image for Openhab


Official DEMO Included
========

If you do not have a openHAB configuration yet, you can start this Docker without one. The official openHAB DEMO will be started. 

PULL
=======
```docker pull jshridha/openhab:1.7.0-release-20150816```

Building
========

```docker build -t <username>/openhab:<tag>```

Running
=======

* The image exposes openHAB ports 8080, 8443, 5555 and 9001 (supervisord).
* It expects you to make a configurations directory on the host to /etc/openhab.  This allows you to inject your openhab configuration into the container (see example below).
* If no configuration is initially specified, the demo files are used and copied to the volume mount path (/etc/openhab)

* The openHAB process is managed using supervisord.  You can manage the process (and view logs) by exposing port 9001.
* The container supports starting without network (--net="none"), and adding network interfaces using pipework.
* You can add a timezone file in the configurations directory, which will be placed in /etc/timezone. Default: UTC

**Example**: content for timezone:
```
Europe/Brussels
```

**Example**: run command (with or without your openHAB config)
```
docker run -d -p 8080:8080 -v /mnt/cache/appdata/openhab/config:/etc/openhab/ jshridha/openhab:1.7.0-release-20150816
```

**Example**: run command (only Demo)
```
docker run -d -p 8080:8080 jshridha/openhab:1.7.0-release-20150816
```
Start the demo with:
```
http://[IP-of-Docker-Host]:8080/openhab.app?sitemap=demo
```
**Example**: Map configuration and logging directory as well as allow access to Supervisor:
```
docker run -d -p 8080:8080 -p 9001:9001 -v /mnt/cache/appdata/openhab/config:/etc/openhab -v /mnt/cache/appdata/openhab/logs:/opt/openhab/logs jshridha/openhab:1.7.0-release-20150816
```
Access Supervisor with:
```
http://[IP-of-Docker-Host]:9001
```
HABmin
=======

HABmin is included by default in this image. Access it by browsing to:
```
http://[IP-of-Docker-Host]:8080/habmin/
```

Contributors
============
* maddingo
* scottt732
* TimWeyand
* dprus
* tdeckers
* jshridha
* wetware