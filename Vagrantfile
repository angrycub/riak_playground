# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.forward_x11 = true

  config.vm.box = "bento/centos-6.7"
  config.vm.network "private_network", type: "dhcp"
  config.vm.hostname = "node1.riak.local"


## Riak OSS

  # config.vm.define "riak_1.4.10" do |riak|
  #   riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.10.sh"
  # end

  config.vm.define "riak_1.4.12" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.12.sh"
  end

  config.vm.define "riak_2.0.5" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
      env: { :RIAK_VERSION => "2.0.5" }
  end

  # config.vm.define "riak_2.1.1" do |riak|
  #   riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
  #     env: { :RIAK_VERSION => "2.1.1" }
  # end

  config.vm.define "riak_2.1.2" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
      env: { :RIAK_VERSION => "2.1.2" }
  end

   config.vm.define "riak_2.1.3" do |riak|
     riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
      env: { :RIAK_VERSION => "2.1.3" }
   end

  config.vm.define "riak_2.1.4" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
      env: { :RIAK_VERSION => "2.1.4" }
  end

## Riak EE -- Requires that the rpms be pre-downloaded.

  # config.vm.define "riak-ee_2.0.5" do |riak|
  #   riak.vm.provision "riak", type: "shell", path: "bin/provision_riak-ee_2.0.5.sh"
  #   riak.vm.hostname = "node1.riak.local"
  # end

  config.vm.define "riak-ee_2.0.6" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak-ee_2.0.6.sh"
    riak.vm.hostname = "node1.riak.local"
  end

  # config.vm.define "riak-ee_2.1.1" do |riak|
  #   riak.vm.provision "riak", type: "shell", path: "bin/provision_riak-ee_2.1.1.sh"
  # end

  # config.vm.define "riak-ee_2.1.3" do |riak|
  #   riak.vm.provision "riak", type: "shell", path: "bin/provision_riak-ee_2.1.3.sh"
  # end

  config.vm.define "riak-ee_2.1.4" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak-ee_2.1.4.sh"
  end

## Riak TS

  config.vm.define "riak-ts_1.3.0" do |riak|
    riak.vm.provision "riak", type: "shell", path: "bin/provision_riak-ts_1.3.0.sh"
  end

## Riak CS

  config.vm.define "riak-cs_1.4.5" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.8.sh"
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_1.4.3.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_1.4.5.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
  end

  config.vm.define "riak-cs_1.5.2" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.12.sh"
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_1.5.0.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_1.5.2.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
  end

  config.vm.define "riak-cs_1.5.4" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_1.4.12.sh"
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_1.5.0.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_1.5.4.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
  end

  config.vm.define "riak-cs_2.0.1" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
        env: { :RIAK_VERSION => "2.0.5" }
    riakcs.vm.provision "stanchion", type: "shell", path: "bin/provision_stanchion_2.0.0.sh"
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_2.0.1.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
  end

  config.vm.define "riak-cs_2.1.0" do |riakcs|
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.1.3.sh"
    riakcs.vm.provision "riak", type: "shell", path: "bin/provision_riak_2.sh", 
        env: { :RIAK_VERSION => "2.1.3" }
    riakcs.vm.provision "riak-cs", type: "shell", path: "bin/provision_riak-cs_2.1.0.sh"
    riakcs.vm.provision "s3_clients", type: "shell", path: "bin/provision_s3_clients.sh"
  end

end
