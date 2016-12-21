#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_riak -- Installs and configures Riak as a cluster of 1

RIAK_TS_VERSION_MAJOR_MINOR=`echo ${RIAK_TS_VERSION} | awk -F'.' '{print $1"."$2}'`
RIAK_EE_HASH=""

RPM_PATH="/vagrant/data/rpmcache/riak-ts-${RIAK_TS_VERSION}-1.el6.x86_64.rpm"
PACKAGE_URL="http://s3.amazonaws.com/downloads.basho.com/riak_ts/${RIAK_TS_VERSION_MAJOR_MINOR}/${RIAK_TS_VERSION}/rhel/6/riak-ts-${RIAK_TS_VERSION}-1.el6.x86_64.rpm"

echo "Installing Riak TS $RIAK_TS_VERSION..."

echo "* Checking for cached components"
if [ ! -f ${RPM_PATH} ] 
  then
    echo "   - Downloading Riak TS $RIAK_TS_VERSION Package into cache"
    wget -q --output-document=${RPM_PATH} ${PACKAGE_URL}
fi

echo "* Installing Riak TS Package"
yum -y --nogpgcheck --noplugins localinstall ${RPM_PATH}

if [ ! -d "/etc/riak" ] 
  then
    echo "No Riak directory found after installation.  Aborting..."
    exit 1
fi

echo "* Installing JRE for Riak (if available)"
JAVA_RPM_PATH="/vagrant/data/rpmcache/jre-7u25-linux-x64.rpm" 
if [ -f "${JAVA_RPM_PATH}" ] 
  then
    yum -y --nogpgcheck --noplugins localinstall ${JAVA_RPM_PATH}
  else
  	echo "  ** JRE RPM (jre-7u25-linux-x64.rpm) not found in rpmcache file; skipping."
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

# Due to a bug in riak-shell, the protocol buffer must be specified and must be a single ip address
# or 0.0.0.0:8087.
echo ""
echo "* Configuring PB Listener to $IP_ADDRESS (because https://github.com/basho/riak_shell/issues/53)"
echo "listener.protobuf.internal = $IP_ADDRESS:8087" >> /etc/riak/riak.conf

insert_attribute riak riak@$IP_ADDRESS
insert_service riak riak@$IP_ADDRESS

echo "* Enabling and Starting Riak TS"
chkconfig riak on
service riak start
