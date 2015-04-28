# Openhab 1.6.2
# * configuration is injected
#
FROM ubuntu:14.04

RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install unzip supervisor wget && \
  apt-get -y clean

WORKDIR /root

# Download and install Oracle JDK
ADD jdk-7u67-linux-x64.tar.gz /opt/
RUN ln -s /opt/jdk1.7.0_67 /opt/jdk7

ENV OPENHAB_VERSION SNAPSHOT

ADD files /root/docker-files/

RUN \
  chmod +x /root/docker-files/scripts/download_openhab.sh  && \
  cp /root/docker-files/pipework /usr/local/bin/pipework && \
  cp /root/docker-files/supervisord.conf /etc/supervisor/supervisord.conf && \
  cp /root/docker-files/openhab.conf /etc/supervisor/conf.d/openhab.conf && \
  cp /root/docker-files/boot.sh /usr/local/bin/boot.sh && \
  cp /root/docker-files/openhab-restart /etc/network/if-up.d/openhab-restart && \
  mkdir -p /opt/openhab/logs && \
  chmod +x /usr/local/bin/pipework && \
  chmod +x /usr/local/bin/boot.sh && \
  chmod +x /etc/network/if-up.d/openhab-restart && \
  rm -rf /tmp/*

#
# Download openHAB based on Environment OPENHAB_VERSION
#
RUN /root/docker-files/scripts/download_openhab.sh

EXPOSE 8080 8443 5555 9001

CMD ["/usr/local/bin/boot.sh"]
