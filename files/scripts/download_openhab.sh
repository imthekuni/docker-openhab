#!/bin/bash


if [[ $OPENHAB_VERSION == "SNAPSHOT" ]]
then
  wget --quiet --no-check-certificate --no-cookies -O /tmp/distribution-runtime.zip https://openhab.ci.cloudbees.com/job/openHAB/lastBuild/artifact/distribution/target/distribution-1.8.0-SNAPSHOT-runtime.zip
  wget --quiet --no-check-certificate --no-cookies -O /tmp/distribution-addons.zip https://openhab.ci.cloudbees.com/job/openHAB/lastBuild/artifact/distribution/target/distribution-1.8.0-SNAPSHOT-addons.zip
  wget --quiet --no-check-certificate --no-cookies -O /tmp/demo-openhab.zip https://openhab.ci.cloudbees.com/job/openHAB/lastBuild/artifact/distribution/target/distribution-1.8.0-SNAPSHOT-demo.zip
else
  wget --quiet --no-check-certificate --no-cookies -O /tmp/distribution-runtime.zip https://bintray.com/artifact/download/openhab/bin/distribution-$OPENHAB_VERSION-runtime.zip
  wget --quiet --no-check-certificate --no-cookies -O /tmp/distribution-addons.zip https://bintray.com/artifact/download/openhab/bin/distribution-$OPENHAB_VERSION-addons.zip
  wget --quiet --no-check-certificate --no-cookies -O /tmp/demo-openhab.zip https://bintray.com/artifact/download/openhab/bin/distribution-$OPENHAB_VERSION-demo.zip
fi

wget --quiet --no-check-certificate --no-cookies -O /tmp/org.openhab.io.myopenhab-1.7.0.jar https://bintray.com/artifact/download/openhab/mvn/org/openhab/io/org.openhab.io.myopenhab/1.7.0/org.openhab.io.myopenhab-1.7.0.jar
wget --quiet --no-check-certificate --no-cookies -O /tmp/hyperic-sigar-1.6.4.tar.gz http://downloads.sourceforge.net/project/sigar/sigar/1.6/hyperic-sigar-1.6.4.tar.gz
wget --quiet --no-check-certificate --no-cookies -O /tmp/habmin.zip https://github.com/cdjackson/HABmin/releases/download/0.1.3-snapshot/habmin.zip

rm -rf /opt/openhab
mkdir -p /opt/openhab/addons-available
mkdir -p /opt/openhab/logs
mkdir -p /opt/openhab/lib
tar -zxf /tmp/hyperic-sigar-1.6.4.tar.gz --wildcards --strip-components=2 -C /opt/openhab hyperic-sigar-1.6.4/sigar-bin/lib/*
unzip -q -d /opt/openhab /tmp/distribution-runtime.zip && rm -rf /opt/openhab/addons
unzip -q -d /opt/openhab/addons-available /tmp/distribution-addons.zip
unzip -q -d /opt/openhab/demo-configuration /tmp/demo-openhab.zip
unzip -q -d /opt/openhab/habmin /tmp/habmin.zip
chmod +x /opt/openhab/start.sh
mv /tmp/org.openhab.io.myopenhab-1.7.0.jar /opt/openhab/addons-available
mkdir /etc/openhab