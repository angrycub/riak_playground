#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_riak -- Installs and configures Riak as a cluster of 1

RIAK_VERSION_MAJOR_MINOR=`echo ${RIAK_VERSION} | awk -F'.' '{print $1"."$2}'`
RIAK_EE_HASH=""

RPM_PATH="/vagrant/data/rpmcache/riak-${RIAK_VERSION}-1.el6.x86_64.rpm"
PACKAGE_URL="http://s3.amazonaws.com/downloads.basho.com/riak/${RIAK_VERSION_MAJOR_MINOR}/${RIAK_VERSION}/rhel/6/riak-${RIAK_VERSION}-1.el6.x86_64.rpm"

echo "Installing Riak $RIAK_VERSION..."

echo "* Checking for cached components"
if [ ! -f ${RPM_PATH} ] 
  then
    echo "   - Downloading Riak $RIAK_VERSION Package into cache"
    wget -q --output-document=${RPM_PATH} ${PACKAGE_URL}
fi

echo "* Installing Riak Package"
yum -y --nogpgcheck --noplugins localinstall ${RPM_PATH}

if [ ! -d "/etc/riak" ] 
  then
    echo "No Riak directory found after installation.  Aborting..."
    exit 1
fi

echo "* Increasing File Limits"
echo '
# Added by Vagrant Provisioning Script
# ulimit settings for Riak
root soft nofile 65536
root hard nofile 65536
riak soft nofile 65536
riak hard nofile 65536

'  >> /etc/security/limits.conf

echo ""
echo "* Configuring node as riak@$IP_ADDRESS "
echo '
# Added by Vagrant Provisioning Script'  >> /etc/riak/riak.conf
echo "nodename = riak@$IP_ADDRESS" >> /etc/riak/riak.conf

insert_attribute riak riak@$IP_ADDRESS
insert_service riak riak@$IP_ADDRESS

echo "* Enabling and Starting Riak"
chkconfig riak on
service riak start
