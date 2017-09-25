FROM tomcat:8.0.20-jre8
MAINTAINER yannisxar


RUN mkdir /usr/local/tomcat/filesystem
ADD /WebMIPMap/ /usr/local/tomcat/filesystem/
RUN touch /usr/local/tomcat/bin/setenv.sh
RUN echo "export MIPMAP_HOME=/usr/local/tomcat/filesystem/ export DB_IP=172.17.0.2" > /usr/local/tomcat/bin/setenv.sh
COPY /WebMIPMap.war /usr/local/tomcat/webapps/WebMIPMap.war
