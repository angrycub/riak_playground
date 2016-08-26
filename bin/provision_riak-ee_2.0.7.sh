#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_riak -- Installs and configures Riak as a cluster of 1
rpm_dest_path="/vagrant/data/rpmcache/riak-ee-2.0.7-1.el6.x86_64.rpm"

echo "Installing Riak..."

echo "* Checking for cached components"
if [ ! -f "${rpm_dest_path}" ] 
  then
    echo "ERROR: Please download riak-ee-2.0.7-1.el6.x86_64 and place into data/rpmcache"
    exit 1
fi

echo "* Installing Riak Package"
yum -y --nogpgcheck --noplugins localinstall ${rpm_dest_path}

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
