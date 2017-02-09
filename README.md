# Oracle-Enterprice
Image for running Oracle Database 11g Standard/Enterprise. Due to oracle license restrictions image is not contain database itself and will install it on first run from external directory.

``This image for development use only.``

Download database installation files from Oracle official site and unpack them to install_folder (It is tested with the linux.x64_11gR2 (11.2.0.1.0) version only). The operative system user is solutions.

This container has the following characteristics:
- Container nfqsolutions/centos:7.
- The oracle directory is "/u01".
- Installations script of oracle in centos. This script copy oracle directory to volumen. This script is executing in the next containers or in the docker compose.
- You must unzip "oracle-xe-11.2.0-1.0.x86_64.rpm.zip" to your volumen "mydirectory". The path "mydirectory/Disk1/*.rpm" must exit.
- You must modify file "mydirectory/Disk1/response/xe.rsp". The password to users SYS and SYSTEM is environment variable, you must define in docker-compose.yml.

For example, docker-compose.yml:

* LINUX
```
server:
 image: nfqsolutions/oracle-enterprise
 privileged: true
 restart: always
 container_name: oracle-server
 ports:
  - "1521:1521"
  - "8080:8080"
 environment:
  - PACKAGES=
 volumes:
  - <mydirectory>:/u01
```


* WINDOWS
```
server:
 image: nfqsolutions/oracle-enterprise
 privileged: true
 restart: always
 container_name: oracle-server
 ports:
  - "1521:1521"
  - "8080:8080"
 environment:
  - PACKAGES=
  - DOWNLOAD_URL=<download_url>/database.tar.gz
```

Usage
=====
Then you can create databases and delete databases in this container. The database user is SYS/SYS, the port is 1521 and the SID is <NAME>.

Create database
-----
```
docker exec -it oracle_server new_database <NAME>
```

Delete database
-----
```
docker exec -it oracle_server delete_database <NAME>
```