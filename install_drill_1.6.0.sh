#!/usr/bin/env bash
#set -x

echo "Importing HDI helper methods..."
wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh

echo "Setting Drill variables..."
DRILL_VERSION=1.6.0
DRILL_TAR_FILE=apache-drill-$DRILL_VERSION.tar.gz
DRILL_DOWNLOAD_URI=http://mirrors.ocf.berkeley.edu/apache/drill/drill-$DRILL_VERSION/$DRILL_TAR_FILE
DRILL_INSTALL_PATH=/usr/local/drill
DRILL_CUSTOM_JAR_PATH=$DRILL_INSTALL_PATH/apache-drill-$DRILL_VERSION/jars/3rdparty

echo "Setting Azure dependency variables (for Azure storage support)..."
HADOOP_AZURE_VERSION=2.7.2
HADOOP_AZURE_JAR_FILE=hadoop-azure-$HADOOP_AZURE_VERSION.jar
HADOOP_AZURE_JAR_URI=http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure/$HADOOP_AZURE_VERSION/$HADOOP_AZURE_JAR_FILE
AZURE_STORAGE_VERSION=4.2.0
AZURE_STORAGE_JAR_FILE=azure-storage-$AZURE_STORAGE_VERSION.jar
AZURE_STORAGE_JAR_URI=http://central.maven.org/maven2/com/microsoft/azure/azure-storage/$AZURE_STORAGE_VERSION/$AZURE_STORAGE_JAR_FILE
# Azure Data Lake is still in preview, can only find the jars in the cluster
AZURE_ADL_JAR_PATH=/usr/lib/hdinsight-datalake

echo "Downloading Drill..."
download_file $DRILL_DOWNLOAD_URI /tmp/$DRILL_TAR_FILE

echo "Extracting Drill to ${DRILL_INSTALL_PATH}..."
if [ -d "$DRILL_INSTALL_PATH" ]; then
  echo "Drill directory already exists, removing for new install..."
  rm -r $DRILL_INSTALL_PATH
fi
mkdir $DRILL_INSTALL_PATH
untar_file /tmp/$DRILL_TAR_FILE $DRILL_INSTALL_PATH

echo "Installing Hadoop Azure Storage support files..."
download_file $HADOOP_AZURE_JAR_URI $DRILL_CUSTOM_JAR_PATH/$HADOOP_AZURE_JAR_FILE
download_file $AZURE_STORAGE_JAR_URI $DRILL_CUSTOM_JAR_PATH/$AZURE_STORAGE_JAR_FILE
cp $AZURE_ADL_JAR_PATH/*.jar $DRILL_CUSTOM_JAR_PATH
#specific HDFS file has Oauth implemented (which is "officially" only coming in the 2.8 release...)
# cp /usr/hdp/2.4.2.0-258/hadoop/client/hadoop-hdfs-2.7.1.2.4.2.0-258.jar ./jars/3rdparty/
#okhttp utilized by data lake
#cp /usr/hdp/2.4.2.0-258/hadoop/client/okhttp-2.4.0.jar ./jars/3rdparty/
#okio also utilized
#cp /usr/hdp/2.4.2.0-258/hadoop/client/okio-1.4.0.jar ./jars/3rdparty/

#TODO Required config values for core-site.xml in /conf (blob storage, data lake storage)

echo "Cleaning up..."
rm /tmp/$DRILL_TAR_FILE

echo "Done!"
