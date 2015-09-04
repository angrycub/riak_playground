#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_riak -- Installs and configures Riak CS

echo "Installing Riak CS..."

echo "* Checking for cached components"
if [ ! -f "/vagrant/data/rpmcache/riak-cs-1.5.4-1.el6.x86_64.rpm" ] 
  then
    echo "   - Downloading Riak CS 1.5.4 Package into cache"
    wget -q --output-document=/vagrant/data/rpmcache/riak-cs-1.5.4-1.el6.x86_64.rpm http://s3.amazonaws.com/downloads.basho.com/riak-cs/1.5/1.5.4/rhel/6/riak-cs-1.5.4-1.el6.x86_64.rpm
fi

echo "* Installing Riak CS Package"
yum -y --nogpgcheck --noplugins localinstall /vagrant/data/rpmcache/riak-cs-1.5.4-1.el6.x86_64.rpm

if [ ! -d "/etc/riak-cs" ] 
  then
    echo "No /etc/riak-cs directory found after installation.  Aborting..."
    exit 1
fi

echo ""
insert_attribute riak-cs $IP_ADDRESS
insert_service riak-cs $IP_ADDRESS

echo "* Reconfiguring Riak"
riak stop
cd /etc/riak

mv /etc/riak/app.config /etc/riak/app.config.orig
sed 's/{storage_backend,/%%{storage_backend,/g' app.config.orig > app.config.tmp
csplit /etc/riak/app.config.tmp "/%%{storage_backend/"
cat xx00 /vagrant/data/templates/riak-cs_1.5.4_riak_config.fragment.1 xx01 > app.config
rm -f xx* /etc/riak/app.config.tmp

mv /etc/riak/app.config /etc/riak/app.config.tmp
csplit /etc/riak/app.config.tmp "/{riak_core,/+1"
cat xx00 /vagrant/data/templates/riak-cs_1.5.4_riak_config.fragment.2 xx01 > app.config
rm -f xx* /etc/riak/app.config.tmp

riak start
riak-admin "wait-for-service" riak_kv riak@$IP_ADDRESS

echo "* Enabling and Starting Riak"
chkconfig riak-cs on

echo "Creating Admin User..."
echo "* Enabling Anonymous User Creation"

cd /etc/riak-cs
mv /etc/riak-cs/app.config /etc/riak-cs/app.config.tmp
sed 's/{anonymous_user_creation, false},/{anonymous_user_creation, true},/g' /etc/riak-cs/app.config.tmp > /etc/riak-cs/app.config
rm -f /etc/riak-cs/app.config.tmp
chown riak:riak /etc/riak-cs/app.config

echo "* Starting Riak CS"
riak-cs start

echo "* Making Admin User"
curl -s -XPOST http://127.0.0.1:8080/riak-cs/user \
     -H 'Content-Type: application/json' \
     -d '{"email":"admin@admin.com", "name":"admin"}' > /vagrant/clusters/admin.json

echo "* Making Test User 1 (bob)"
curl -s -XPOST http://127.0.0.1:8080/riak-cs/user \
     -H 'Content-Type: application/json' \
     -d '{"email":"bob@admin.com", "name":"bob"}' > /vagrant/clusters/bob.json

echo "* Making Test User 2 (carol)"
curl -s -XPOST http://127.0.0.1:8080/riak-cs/user \
     -H 'Content-Type: application/json' \
     -d '{"email":"carol@admin.com", "name":"carol"}' > /vagrant/clusters/carol.json

echo "* Making Test User 3 (ted)"
curl -s -XPOST http://127.0.0.1:8080/riak-cs/user \
     -H 'Content-Type: application/json' \
     -d '{"email":"ted@admin.com", "name":"ted"}' > /vagrant/clusters/ted.json

echo "* Making Test User 4 (alice)"
curl -s -XPOST http://127.0.0.1:8080/riak-cs/user \
     -H 'Content-Type: application/json' \
     -d '{"email":"alice@admin.com", "name":"alice"}' > /vagrant/clusters/alice.json

echo "* Stopping Riak CS"
riak-cs stop

echo "* Disabling Anonymous User Creation"
mv /etc/riak-cs/app.config /etc/riak-cs/app.config.tmp
sed 's/{anonymous_user_creation, true},/{anonymous_user_creation, false},/g' /etc/riak-cs/app.config.tmp > /etc/riak-cs/app.config
rm -f /etc/riak-cs/app.config.tmp
chown riak:riak /etc/riak-cs/app.config

echo "* Stopping Stanchion"
stanchion stop

echo "* Configuring Stanchion"
mv /etc/stanchion/app.config /etc/stanchion/app.config.tmp
sed "s/admin-key/`/usr/local/bin/jq -r .key_id /vagrant/clusters/admin.json`/g" /etc/stanchion/app.config.tmp |
sed "s/admin-secret/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/admin.json`/g" >> /etc/stanchion/app.config
rm -f /etc/stanchion/app.config.tmp
chown stanchion:riak /etc/stanchion/app.config

echo "* Starting Stanchion"
stanchion start

echo "* Configuring Riak CS"
mv /etc/riak-cs/app.config /etc/riak-cs/app.config.tmp
sed "s/admin-key/`/usr/local/bin/jq -r .key_id /vagrant/clusters/admin.json`/g" /etc/riak-cs/app.config.tmp |
sed "s/admin-secret/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/admin.json`/g" >> /etc/riak-cs/app.config
rm -f /etc/riak-cs/app.config.tmp
chown riak:riak /etc/riak-cs/app.config

echo "* Restarting Riak CS"
riak-cs start 
