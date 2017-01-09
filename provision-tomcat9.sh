#!/bin/sh

# provision.sh

echo "provision-tomcat9.pwd: ${0}"

# Destination folder
DEST=/home/vagrant

# apache tomcat 9
#http://ftp.unicamp.br/pub/apache/tomcat/tomcat-9/v9.0.0.M4/bin/apache-tomcat-9.0.0.M4.tar.gz
#http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-9/v9.0.0.M8/bin/apache-tomcat-9.0.0.M8.tar.gz
#http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-9/v9.0.0.M9/bin/apache-tomcat-9.0.0.M9.tar.gz
#http://ftp.unicamp.br/pub/apache/tomcat/tomcat-9/v9.0.0.M10/bin/apache-tomcat-9.0.0.M10.tar.gz
#http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-9/v9.0.0.M11/bin/apache-tomcat-9.0.0.M11.tar.gz

TOMCAT="apache-tomcat"
TOMCAT_MAJOR_V="9"
TOMCAT_MINOR_V="0.0"
TOMCAT_REV="M15"
TOMCAT_V=${TOMCAT_MAJOR_V}.${TOMCAT_MINOR_V}.${TOMCAT_REV}
TOMCAT_VERSION=$TOMCAT-$TOMCAT_V
TOMCAT_GZ=$TOMCAT_VERSION.tar.gz
TOMCAT_DESCRIPTION="Apache Tomcat9 $isv"
TOMCAT_DOWNLOAD_URL="http://ftp.unicamp.br/pub/apache/tomcat/tomcat-${TOMCAT_MAJOR_V}/v${TOMCAT_V}/bin/${TOMCAT_GZ}"

# Tomcat config
TOMCAT_CONF=/opt/$TOMCAT/conf/server.xml
#OFFSET="0"

#echo .
#echo installing unzip 
#sudo apt-get update
#sudo apt-get install unzip

if [ -f /vagrant/$TOMCAT_GZ ]; then 
    echo .
    echo Copying $TOMCAT_VERSION
    cp -f /vagrant/$TOMCAT_GZ $DEST
else
	echo .
	echo Downloading $TOMCAT_GZ
    wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  $TOMCAT_DOWNLOAD_URL
    cp $TOMCAT_GZ /vagrant
fi

echo .
ls $DEST/*.tar.gz

echo .
echo Uncompressing $TOMCAT_GZ
tar -xf $TOMCAT_GZ

#echo .
#echo Unzipping $TOMCAT_GZ
#cd $DEST
#unzip -o -q $TOMCAT_GZ

#echo .
#echo Removing $TOMCAT_GZ
#rm -f $TOMCAT_GZ

echo .
echo moving $TOMCAT_VERSION folder to /opt
rm -rf /opt/$TOMCAT_VERSION
mv -f $TOMCAT_VERSION /opt
ls -lahd /opt/$TOMCAT_VERSION

echo .
echo chown to vagrant
chown -R vagrant:vagrant /opt/$TOMCAT_VERSION
ls -lahd /opt/$TOMCAT_VERSION

echo .
echo sym-linking to $TOMCAT_VERSION
ln -s /opt/$TOMCAT_VERSION /opt/$TOMCAT
ls -lah /opt/$TOMCAT

echo .
echo Setting up CATALINA_HOME for vagrant user
echo "" >> /home/vagrant/.profile
echo export CATALINA_HOME=/opt/$TOMCAT >> /home/vagrant/.profile


# source /home/vagrant/.profile
export JAVA_HOME=/usr/java/jdk1.8.0_112

echo .
echo Copying /vagrant/hello.war
cp -f /vagrant/hello.war $DEST
cp -f /vagrant/hello.war /opt/$TOMCAT/webapps
chmod a+x /opt/$TOMCAT/bin/startup.sh
/opt/$TOMCAT/bin/startup.sh
