# Docker container for WebMIPMap

This container expects the following to be defined:

```yml
  ports:
   - "80:8080"
  volumes:
   - "${webmipmap_home}:/usr/local/tomcat/webmipmap:rw"
```

Once the container is started tomcat will answer request on the the
selected port, and WebMIPMap will be accessible at ```/webmipmap```.
