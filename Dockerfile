# Using ubuntu 14.04 as base
FROM ubuntu:14.04

#install Oracle JDK
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get -y upgrade

# automatically accept Oracle license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# and install java 7 oracle jdk
RUN apt-get -y install oracle-java7-installer && apt-get clean
RUN update-alternatives --display java 
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

RUN apt-get update && apt-get -y install nginx --no-install-recommends

WORKDIR /usr/local/mirthconnect

ADD templates/mirthconnect/mirthconnect-install-wrapper.sh /usr/local/mirthconnect/mirthconnect-install-wrapper.sh
 
RUN wget http://downloads.mirthcorp.com/connect/3.3.0.7801.b1804/mirthconnect-3.3.0.7801.b1804-unix.sh \
 && chmod +x mirthconnect-3.3.0.7801.b1804-unix.sh \
 && ./mirthconnect-install-wrapper.sh

ADD templates/etc /etc
ADD templates/mirthconnect /usr/local/mirthconnect

#Exposing ports that will be used by container; 80, 443, 9600 - 9700 (defining a port range to be used by development channels)
EXPOSE 3000 9600-9700 80 443

CMD ./mirthconnect-wrapper.sh
