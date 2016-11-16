#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_riak-ee -- Installs and configures Riak as a cluster of 1

RPM_PATH="/vagrant/data/rpmcache/riak-ee-${RIAK_VERSION}-1.el6.x86_64.rpm"





echo "Installing Riak $RIAK_VERSION..."

echo "* Checking for cached components"
if [ ! -f "${RPM_PATH}" ] 
  then
    echo "ERROR: Please download riak-ee-${RIAK_VERSION}-1.el6.x86_64.rpm and place into data/rpmcache"
    exit 1
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

export REX_VERSION="1.2.3" 
/vagrant/bin/provision_rex_patch.sh

echo ""
echo "* Configuring node as riak@$IP_ADDRESS "
echo '
# Added by Vagrant Provisioning Script'  >> /etc/riak/riak.conf
echo "nodename = riak@${IP_ADDRESS}" >> /etc/riak/riak.conf
echo "listener.http.provisioned = ${IP_ADDRESS}:8098" >> /etc/riak/riak.conf

insert_attribute riak riak@$IP_ADDRESS
insert_service riak riak@$IP_ADDRESS

echo "* Enabling and Starting Riak"
chkconfig riak on
service riak start
