#!/usr/bin/env bash
set -x

#Drill variables
DRILL_INSTALL_PATH=/usr/local/drill
DRILL_VERSION=1.6.0
DRILL_TAR_FILE=apache-drill-$DRILL_VERSION.tar.gz
DRILL_DOWNLOAD_URI=http://mirrors.ocf.berkeley.edu/apache/drill/drill-$DRILL_VERSION/$DRILL_TAR_FILE

#Azure dependency variables
HADOOP_AZURE_VERSION=2.7.2
HADOOP_AZURE_JAR_FILE=hadoop-azure-$HADOOP_AZURE_VERSION.jar
HADOOP_AZURE_JAR_URI=http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure/$HADOOP_AZURE_VERSION/$HADOOP_AZURE_JAR_FILE

#Download and install/extract drill
mkdir $DRILL_INSTALL_PATH
cd $DRILL_INSTALL_PATH
wget $DRILL_DOWNLOAD_URI
tar -xzf $DRILL_TAR_FILE
