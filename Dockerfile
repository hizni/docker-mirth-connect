#FROM gliderlabs/alpine:3.3

#RUN apk --update add openjdk7-jre
#RUN apk --update add gzip
#RUN apk --update add unzip
#RUN apk --update add xvfb
#RUN apk --update add libx11
#RUN apk --update add bash && rm -rf /var/cache/apk/*

#RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
#RUN apk --update add xpra

#RUN apk update add && \ 
#    apk add alpine-desktop xfce4

#RUN apk --update add alpine-desktop

#RUN apt-get update && apt-get -y install nginx --no-install-recommends
# Install nginx
#RUN apk add --update nginx=1.8.1-r0 && \
#    rm -rf /var/cache/apk/* 
    #chown -R nginx:www-data /var/lib/nginx

#WORKDIR /usr/local/mirthconnect

#ADD templates/mirthconnect/mirthconnect-install-wrapper.sh /usr/local/mirthconnect/mirthconnect-install-wrapper.sh
 
#RUN wget http://downloads.mirthcorp.com/connect/3.3.0.7801.b1804/mirthconnect-3.3.0.7801.b1804-unix.sh && \
#   chmod +x mirthconnect-3.3.0.7801.b1804-unix.sh && \
#	./mirthconnect-install-wrapper.sh

#ADD templates/etc /etc
#ADD templates/mirthconnect /usr/local/mirthconnect

#Exposing ports that will be used by container; 80, 443, 9661
#EXPOSE 3000 9661 80 443

#CMD ./mirthconnect-wrapper.sh


# Using ubuntu 14.04 as base
FROM ubuntu:14.04


# Install Java.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

# Install Nginx
RUN apt-get update && apt-get -y install nginx --no-install-recommends

# Install Mirth Connect 3.3.0
WORKDIR /usr/local/mirthconnect

ADD templates/mirthconnect/mirthconnect-install-wrapper.sh /usr/local/mirthconnect/mirthconnect-install-wrapper.sh
 
RUN wget http://downloads.mirthcorp.com/connect/3.3.0.7801.b1804/mirthconnect-3.3.0.7801.b1804-unix.sh \
 && chmod +x mirthconnect-3.3.0.7801.b1804-unix.sh \
 && ./mirthconnect-install-wrapper.sh

ADD templates/etc /etc
ADD templates/mirthconnect /usr/local/mirthconnect

#Exposing ports that will be used by container; 80, 443, 9661
EXPOSE 3000 9661 80 443

CMD ./mirthconnect-wrapper.sh
