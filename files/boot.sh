#!/bin/bash

CONFIG_DIR=/etc/openhab/

####################
# Configure timezone

TIMEZONEFILE=$CONFIG_DIR/timezone

if [ -f "$TIMEZONEFILE" ]
then
  cp $TIMEZONEFILE /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

###########################
# Configure Addon libraries

SOURCE=/opt/openhab/addons-available
DEST=/opt/openhab/addons

if [ -d $CONFIG_DIR/addons ]
then
  ln -s /etc/openhab/addons $DEST
else
  cp -r $SOURCE $CONFIG_DIR/addons 
  ln -s /etc/openhab/addons $DEST
fi

###########################################
# Download Demo if no configuration is given

if [ -f $CONFIG_DIR/openhab.cfg ]
then
  echo configuration found.
  rm -rf /tmp/demo-openhab*
else
  echo --------------------------------------------------------
  echo          NO openhab.cfg CONFIGURATION FOUND
  echo
  echo                = using demo files =
  echo
  echo 
  echo --------------------------------------------------------
  cp -r /opt/openhab/configurations/* /etc/openhab/ && rm -r /opt/openhab/configurations
  ln -s /etc/openhab /opt/openhab/configurations
  cp -r /opt/openhab/demo-configuration/configurations/* /etc/openhab/ && rm -r /opt/openhab/demo-configuration/configurations/*
  cp /etc/openhab/openhab_default.cfg /etc/openhab/openhab.cfg
fi

######################
# Decide how to launch

ETH0_FOUND=`grep "eth0" /proc/net/dev`

if [ -n "$ETH0_FOUND" ] ;
then 
  # We're in a container with regular eth0 (default)
  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else 
  # We're in a container without initial network.  Wait for it...
  /usr/local/bin/pipework --wait
  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
fi
