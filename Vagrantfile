# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "chef/centos-6.5"
  config.vm.provision "riak", type: "shell", path: "bin/provision_riak.sh"
  config.vm.network "private_network", type: "dhcp"

  config.vm.define "riak-cs_1.5.2" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.12.sh"
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_1.5.0.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_1.5.2.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
    riakcs.vm.hostname = "node1.riak.local"
  end

  config.vm.define "riak-cs_1.5.4" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.12.sh"
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_1.5.0.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_1.5.4.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
    riakcs.vm.hostname = "node1.riak.local"
  end

  config.vm.define "riak-cs_2.0.1" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.0.5.sh"
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_2.0.0.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_2.0.1.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
    riakcs.vm.hostname = "node1.riak.local"
  end

  config.vm.define "riak_1.4.12" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.12.sh"
    riak.vm.hostname = "node1.riak.local"
  end

  config.vm.define "riak_2.0.5" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.0.5.sh"
    riak.vm.hostname = "node1.riak.local"
  end

end
