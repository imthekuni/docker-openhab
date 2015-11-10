# Openhab 1.6.2
# * configuration is injected
#
FROM ubuntu:14.04

RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install unzip supervisor wget ssh etherwake && \
  apt-get -y clean && \
  rm -rf /usr/share/locale/* && \
  rm -rf /usr/share/man/* && \
  rm -rf /tmp/*


WORKDIR /root

# Download and install Oracle JDK
# For direct download see: http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/jre-8u45-linux-x64.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jre-8u45-linux-x64.tar.gz && \
    tar -zxC /opt -f /tmp/jre-8u45-linux-x64.tar.gz && \
	ln -s /opt/jre1.8.0_45 /opt/jre8 && \
	rm -rf /tmp/*

ENV OPENHAB_VERSION 1.7.1

ADD files /root/docker-files/

RUN \
  chmod +x /root/docker-files/scripts/download_openhab.sh  && \
  cp /root/docker-files/pipework /usr/local/bin/pipework && \
  cp /root/docker-files/supervisord.conf /etc/supervisor/supervisord.conf && \
  cp /root/docker-files/openhab.conf /etc/supervisor/conf.d/openhab.conf && \
  cp /root/docker-files/openhab_debug.conf /etc/supervisor/conf.d/openhab_debug.conf && \
  cp /root/docker-files/openhab-restart /etc/network/if-up.d/openhab-restart && \
  mkdir -p /opt/openhab/logs && \
  chmod +x /usr/local/bin/pipework && \
  chmod +x /etc/network/if-up.d/openhab-restart && \
  rm -rf /tmp/*

#
# Download openHAB based on Environment OPENHAB_VERSION
#
RUN /root/docker-files/scripts/download_openhab.sh

ADD boot.sh /usr/local/bin/boot.sh
RUN chmod +x /usr/local/bin/boot.sh

RUN rm -rf /root/* && rm -rf /tmp/*

EXPOSE 8080 8443 5555 9001

ENV PATH /opt/jre8/bin:$PATH

RUN usermod -u 99 nobody && \
usermod -g 100 nobody

CMD ["/usr/local/bin/boot.sh"]
