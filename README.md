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
