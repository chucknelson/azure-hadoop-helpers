#!/usr/bin/env bash
set -x

#Drill variables
DRILL_INSTALL_PATH=/usr/local/drill
DRILL_VERSION=1.6.0
DRILL_TAR_FILE=apache-drill-$DRILL_VERSION.tar.gz
DRILL_DOWNLOAD_URI=http://mirrors.ocf.berkeley.edu/apache/drill/drill-$DRILL_VERSION/$DRILL_TAR_FILE

#Azure storage variables


#Download and install/extract drill
mkdir $DRILL_INSTALL_PATH
cd $DRILL_INSTALL_PATH
wget $DRILL_DOWNLOAD_URI
tar -xzf $DRILL_TAR_FILE
