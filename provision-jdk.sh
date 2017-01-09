#!/bin/sh

# provision-jdk.sh

echo "provision-jdk.pwd: ${0}"

# Destination folder
DEST=/home/vagrant

#http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jre-8u92-linux-x64.tar.gz
#http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz

# jdk
jdk="jdk"
jdkmajorv="8"
jdkminorv="0"
jdkupdate="112"
jdkbuild="15"
jdkv="${jdkmajorv}u${jdkupdate}"
jdkversion="1.${jdkmajorv}.${jdkminorv}"
jdkrelease="${jdkv}-b${jdkbuild}"
jdkos="linux"
jdkarc="x64"
jdkzip="${jdk}-${jdkv}-${jdkos}-${jdkarc}.tar.gz"
jdkfolder="${jdk}${jdkversion}_${jdkupdate}"


if [ -f /vagrant/$jdkzip ]; then 
    echo .
    echo Copying $jdkzip
    cp -f /vagrant/$jdkzip $DEST
else
	echo .
	echo Downloading $jdkzip
    wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/$jdkrelease/$jdkzip
    cp $jdkzip /vagrant
fi

echo .
echo Uncompressing $jdkzip
tar -xf $jdkzip

echo .
echo Moving $jdkfolder folder to /usr/java
mkdir -p /usr/java
rm -rf /usr/java/$jdkfolder
mv -f $jdkfolder /usr/java

echo .
echo Removing $jdkzip
rm -f $jdkzip

echo .
echo Setting up JAVA_HOME for vagrant user
echo "" >> /home/vagrant/.profile
echo export JAVA_HOME=/usr/java/$jdkfolder >> /home/vagrant/.profile

