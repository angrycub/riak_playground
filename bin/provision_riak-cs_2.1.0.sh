#! /bin/bash
source /vagrant/bin/provision_helper.sh

# provision_riak-cs -- Installs and configures Riak CS

echo "Installing Riak CS..."

echo "* Checking for cached components"
if [ ! -f "/vagrant/data/rpmcache/riak-cs-2.1.0-1.el6.x86_64.rpm" ] 
  then
    echo "   - Downloading Riak CS 2.0.1 Package into cache"
    wget -q --output-document=/vagrant/data/rpmcache/riak-cs-2.1.0-1.el6.x86_64.rpm http://s3.amazonaws.com/downloads.basho.com/riak-cs/2.1/2.1.0/rhel/6/riak-cs-2.1.0-1.el6.x86_64.rpm
fi

echo "* Installing Riak CS Package"
yum -y --nogpgcheck --noplugins localinstall \
  /vagrant/data/rpmcache/riak-cs-2.1.0-1.el6.x86_64.rpm

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
echo "buckets.default.allow_mult = true" >> /etc/riak/riak.conf

echo '
 {riak_kv, [
              {add_paths, ["/usr/lib64/riak-cs/lib/riak_cs-2.1.0/ebin"]},
              {storage_backend, riak_cs_kv_multi_backend},
              {multi_backend_prefix_list, [{<<"0b:">>, be_blocks}]},
              {multi_backend_default, be_default},
              {multi_backend, [
                  {be_default, riak_kv_eleveldb_backend, [
                      {total_leveldb_mem_percent, 30},
                      {data_root, "/var/lib/riak/leveldb"}
                  ]},
                  {be_blocks, riak_kv_bitcask_backend, [
                      {data_root, "/var/lib/riak/bitcask"}
                  ]}
              ]}
  ]}
' > /etc/riak/advanced.config.cs

if [ ! -f "/etc/riak/advanced.config" ] 
  then
    echo "[" > begin
    echo "]." > end
    cat begin /etc/riak/advanced.config.cs end > /etc/riak/advanced.config
    rm -f begin end
  else
    cp /etc/riak/advanced.config /etc/riak/advanced.config.orig
    sed "s/127.0.0.1/$IP_ADDRESS/g" /etc/riak/advanced.config.orig > /etc/riak/advanced.config
    echo "," > comma
    csplit /etc/riak/advanced.config "/\]\./"
    cat xx00 comma /etc/riak/advanced.config.cs xx01 > /etc/riak/advanced.config
    rm -f xx* comma 
fi

chown riak:riak /etc/riak/advanced.config
rm -f /etc/riak/advanced.config.cs

riak start
riak-admin "wait-for-service" riak_kv riak@$IP_ADDRESS

echo "* Enabling and Starting Riak"
chkconfig riak-cs on


cd /etc/riak-cs
echo "Creating Admin User..."
echo "* Enabling Anonymous User Creation"
echo "anonymous_user_creation = on" >> /etc/riak-cs/riak-cs.conf

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
mv /etc/riak-cs/riak-cs.conf /etc/riak-cs/riak-cs.conf.tmp
grep -v "anonymous_user_creation" /etc/riak-cs/riak-cs.conf.tmp > /etc/riak-cs/riak-cs.conf
rm -f /etc/riak-cs/riak-cs.conf.tmp
chown riak:riak /etc/riak-cs/riak-cs.conf

echo "* Stopping Stanchion"
stanchion stop

echo "* Configuring Stanchion"
mv /etc/stanchion/stanchion.conf /etc/stanchion/stanchion.conf.tmp
sed "s/admin-key/`/usr/local/bin/jq -r .key_id /vagrant/clusters/admin.json`/g" /etc/stanchion/stanchion.conf.tmp |
sed "s/admin-secret/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/admin.json`/g" >> /etc/stanchion/stanchion.conf
rm -f /etc/stanchion/stanchion.conf.tmp
chown stanchion:riak /etc/stanchion/stanchion.conf

echo "* Starting Stanchion"
stanchion start

echo "* Configuring Riak CS"
mv /etc/riak-cs/riak-cs.conf /etc/riak-cs/riak-cs.conf.tmp
sed "s/admin-key/`/usr/local/bin/jq -r .key_id /vagrant/clusters/admin.json`/g" /etc/riak-cs/riak-cs.conf.tmp |
sed "s/admin-secret/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/admin.json`/g" >> /etc/riak-cs/riak-cs.conf
rm -f /etc/riak-cs/riak-cs.conf.tmp
chown riak:riak /etc/riak-cs/riak-cs.conf

echo "* Restarting Riak CS"
riak-cs start 
