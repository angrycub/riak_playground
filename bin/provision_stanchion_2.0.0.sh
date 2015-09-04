#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_stanchion -- Installs and configures Stanchion

echo "Installing Stanchion..."

echo "* Checking for cached components"
if [ ! -f "/vagrant/data/rpmcache/stanchion-2.0.0-1.el6.x86_64.rpm" ] 
  then
    echo "   - Downloading Stanchion 2.0.0 Package into cache"
    wget -q --output-document=/vagrant/data/rpmcache/stanchion-2.0.0-1.el6.x86_64.rpm http://s3.amazonaws.com/downloads.basho.com/stanchion/2.0/2.0.0/rhel/6/stanchion-2.0.0-1.el6.x86_64.rpm
fi

echo "* Installing Stanchion Package"
yum -y --nogpgcheck --noplugins localinstall \
  /vagrant/data/rpmcache/stanchion-2.0.0-1.el6.x86_64.rpm

if [ ! -d "/etc/stanchion" ] 
  then
    echo "No /etc/stanchion directory found after installation.  Aborting..."
    exit 1
fi

insert_attribute stanchion $IP_ADDRESS
insert_service stanchion $IP_ADDRESS

echo "* Enabling and Starting Stanchion"
chkconfig stanchion on
service stanchion start
