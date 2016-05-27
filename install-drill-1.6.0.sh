#!/usr/bin/env bash
#set -x

echo "Importing HDI helper methods..."
wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh

echo "Setting HDI/HDP/Hadoop variables..."
HADOOP_HDP_VERSION=2.4.2.0-258
HADOOP_HDP_JAR_PATH=/usr/hdp/$HADOOP_HDP_VERSION/hadoop

echo "Setting Drill variables..."
DRILL_VERSION=1.6.0
DRILL_TAR_FILE=apache-drill-$DRILL_VERSION.tar.gz
DRILL_DOWNLOAD_URI=http://mirrors.ocf.berkeley.edu/apache/drill/drill-$DRILL_VERSION/$DRILL_TAR_FILE
DRILL_INSTALL_PATH=/usr/local/drill
DRILL_CONF_PATH=$DRILL_INSTALL_PATH/apache-drill-$DRILL_VERSION/conf
DRILL_CUSTOM_JAR_PATH=$DRILL_INSTALL_PATH/apache-drill-$DRILL_VERSION/jars/3rdparty

echo "Setting Azure dependency variables (for Azure storage support)..."
HADOOP_AZURE_VERSION=2.7.2
HADOOP_AZURE_JAR_FILE=hadoop-azure-$HADOOP_AZURE_VERSION.jar
HADOOP_AZURE_JAR_URI=http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure/$HADOOP_AZURE_VERSION/$HADOOP_AZURE_JAR_FILE$AZURE_STORAGE_JAR_FILE
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
cp $HADOOP_HDP_JAR_PATH/hadoop-azure.jar $DRILL_CUSTOM_JAR_PATH #required for adl
download_file $HADOOP_AZURE_JAR_URI $DRILL_CUSTOM_JAR_PATH/$HADOOP_AZURE_JAR_FILE #latest version required for wasb?
cp $HADOOP_HDP_JAR_PATH/lib/azure-storage*.jar $DRILL_CUSTOM_JAR_PATH
cp $HADOOP_HDP_JAR_PATH/client/hadoop-hdfs.jar $DRILL_CUSTOM_JAR_PATH
cp $AZURE_ADL_JAR_PATH/*.jar $DRILL_CUSTOM_JAR_PATH
cp $HADOOP_HDP_JAR_PATH/client/okhttp.jar $DRILL_CUSTOM_JAR_PATH #required for adl
cp $HADOOP_HDP_JAR_PATH/client/okio.jar $DRILL_CUSTOM_JAR_PATH #required for adl

echo "Copying Hadoop config for Drill..."
#TODO - Need many items in this, but copying this whole file causes drill to fail in certai places
cp /etc/hadoop/conf/core-site.xml $DRILL_CONF_PATH

echo "Cleaning up..."
rm /tmp/$DRILL_TAR_FILE

echo "Done!"
