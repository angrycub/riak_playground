#! /bin/bash

echo "Installing S3 Helper Apps..."

echo "* Installing s3cmd"
cp /vagrant/data/repos/s3tools.repo /etc/yum.repos.d
yum -y -q install s3cmd

echo "* Installing s3curl"

echo "    - Installing dependency perl"
yum -y -q install perl perl-Digest-HMAC

echo "    - Installing s3curl.pl"
cp /vagrant/data/applications/s3curl.pl /usr/local/bin
chmod +x /usr/local/bin/s3curl.pl
ln -s /usr/local/bin/s3curl.pl /usr/local/bin/s3curl

echo "* Configuring s3cmd"
cat /vagrant/data/templates/s3cfg.template | 
    sed "s/{{admin_key}}/`/usr/local/bin/jq -r .key_id /vagrant/clusters/admin.json`/" | 
    sed "s/{{admin_secret}}/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/admin.json`/" > /home/vagrant/.s3cfg
chown vagrant:vagrant /home/vagrant/.s3cfg

cat /vagrant/data/templates/s3cfg.template | 
    sed "s/{{admin_key}}/`/usr/local/bin/jq -r .key_id /vagrant/clusters/bob.json`/" | 
    sed "s/{{admin_secret}}/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/bob.json`/" > /home/vagrant/bob.s3
chown vagrant:vagrant /home/vagrant/bob.s3

cat /vagrant/data/templates/s3cfg.template | 
    sed "s/{{admin_key}}/`/usr/local/bin/jq -r .key_id /vagrant/clusters/carol.json`/" | 
    sed "s/{{admin_secret}}/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/carol.json`/" > /home/vagrant/carol.s3
chown vagrant:vagrant /home/vagrant/carol.s3

cat /vagrant/data/templates/s3cfg.template | 
    sed "s/{{admin_key}}/`/usr/local/bin/jq -r .key_id /vagrant/clusters/ted.json`/" | 
    sed "s/{{admin_secret}}/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/ted.json`/" > /home/vagrant/ted.s3
chown vagrant:vagrant /home/vagrant/ted.s3

cat /vagrant/data/templates/s3cfg.template | 
    sed "s/{{admin_key}}/`/usr/local/bin/jq -r .key_id /vagrant/clusters/alice.json`/" | 
    sed "s/{{admin_secret}}/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/alice.json`/" > /home/vagrant/alice.s3
chown vagrant:vagrant /home/vagrant/alice.s3

echo "* Configuring s3curl"
cat /vagrant/data/templates/s3curl.template | 
    sed "s/{{admin_key}}/`/usr/local/bin/jq -r .key_id /vagrant/clusters/admin.json`/" | 
    sed "s/{{admin_secret}}/`/usr/local/bin/jq -r .key_secret /vagrant/clusters/admin.json`/" > /home/vagrant/.s3curl
chown vagrant:vagrant /home/vagrant/.s3curl
chmod 600 /home/vagrant/.s3curl