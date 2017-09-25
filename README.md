# WebMIPMap-docker

------ Working Example Step by Step-------
# Build and run database container
# The dockerfile is located in "db" folder
docker build -t database .
docker run -d --name database database

# Find database container's IP address
docker inspect database | grep '"IPAddress"' | head -n 1

# Change the database's IP address in Web app dockerfile
# The dockerfile is located in "web" folder
in the line RUN echo "export MIPMAP_HOME=/usr/local/tomcat/filesystem/ export DB_IP=172.17.0.96" > /usr/local/tomcat/bin/setenv.sh
change the variable DB_IP with the new database IP address which is acquired from the previous command

# Build and run web app linked with the created database
docker build -t webmipmap .
docker run -d -p 8888:8080 --link database:database --name webmipmap webmipmap


------ Necessary Commands --------
# Build and run database
docker build -t <CONTAINER NAME> .
docker run -d --name <CONTAINER ALIAS> <DB CONTAINER NAME>

# Find container's IP address
docker inspect <CONTAINER NAME> | grep '"IPAddress"' | head -n 1

# Build and run web app linked with the created database
docker build -t webmipmap .
docker run -d -p 8888:8080 --link <CONTAINER ALIAS>:<DB CONTAINER NAME> <WEB CONTAINER NAME>

------ Additional Commands -------

# Container cleanup script
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Image cleanup script
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)
# Docker container for WebMIPMap

Use the following command to build the WebMIPMap image:

```sh
  $ docker build -t hbpmip/webmipmap \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
```
    
This container expects the following to be defined:

```yml
  ports:
   - "80:8080"
  volumes:
   - "${webmipmap_home}:/usr/local/tomcat/webmipmap:rw"
```

Once the container is started tomcat will answer request on the the
selected port, and WebMIPMap will be accessible at ```/webmipmap```.
