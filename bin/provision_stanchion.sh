#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_stanchion -- 

STANCHION_VERSION_MAJOR_MINOR=`echo ${STANCHION_VERSION} | awk -F'.' '{print $1"."$2}'`
STANCHION_EE_HASH=""

RPM_PATH="/vagrant/data/rpmcache/stanchion-${STANCHION_VERSION}-1.el6.x86_64.rpm"
PACKAGE_URL="http://s3.amazonaws.com/downloads.basho.com/stanchion/${STANCHION_VERSION_MAJOR_MINOR}/${STANCHION_VERSION}/rhel/6/stanchion-${STANCHION_VERSION}-1.el6.x86_64.rpm"

echo "Installing Stanchion $STANCHION_VERSION..."

echo "* Checking for cached components"
if [ ! -f ${RPM_PATH} ] 
  then
    echo "   - Downloading Stanchion ${STANCHION_VERSION} Package into cache"
    wget -q --output-document=${RPM_PATH} ${PACKAGE_URL}
fi

echo "* Installing Stanchion Package"
yum -y --nogpgcheck --noplugins localinstall ${RPM_PATH}

if [ ! -d "/etc/stanchion" ] 
  then
    echo "No Stanchion directory found after installation.  Aborting..."
    exit 1
fi

insert_attribute stanchion $IP_ADDRESS
insert_service stanchion $IP_ADDRESS

echo "* Enabling and Starting Stanchion"
chkconfig stanchion on
service stanchion start
