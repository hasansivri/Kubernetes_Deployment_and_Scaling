#FROM nginx
FROM centos:7

RUN  yum install httpd -y 
CMD tail -f /dev/null
