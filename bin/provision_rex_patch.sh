#! /bin/bash

if [ ! -z ${REX_VERSION} ]
  then
    source /vagrant/bin/provision_helper.sh

    # provision_riak_explorer -- 

    REX_VERSION_MAJOR_MINOR=`echo ${REX_VERSION} | awk -F'.' '{print $1"."$2}'`

    RPM_PATH="/vagrant/data/rpmcache/riak_explorer-${REX_VERSION}-centos-7.tar.gz"
    PACKAGE_URL="https://github.com/basho-labs/riak_explorer/releases/download/${REX_VERSION}/riak_explorer-${REX_VERSION}.patch-centos-7.tar.gz"

    echo "Installing Riak Explorer ${REX_VERSION}..."

    echo "* Checking for cached components"
    if [ ! -f ${RPM_PATH} ] 
      then
        echo "   - Downloading Riak Explorer ${REX_VERSION} Package into cache"
        wget -q --output-document=${RPM_PATH} ${PACKAGE_URL}
    fi

    echo "* Installing Riak Explorer into basho-patches"
    if [ ! -d /var/tmp/rex_install ] 
      then
        mkdir /var/tmp/rex_install
    fi
    pushd /var/tmp/rex_install
    tar -zxf ${RPM_PATH}
    cp -R root/riak/priv/* /usr/lib64/riak/priv/
    cp -R root/riak/lib/basho-patches/* /usr/lib64/riak/lib/basho-patches/
    chown -R riak:riak /usr/lib64/riak/lib/basho-patches/
    chown -R riak:riak /usr/lib64/riak/priv/
    popd

  else
    echo "REX_VERSION is undefined; Aborting."
    exit 1
fi
