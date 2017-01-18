## Riak Playground ##

Sometimes you just need to test a specific version of Riak or Riak CS.  This project will let you spin up a single-node cluster. That's right, a single node cluster... the thing you are NEVER EVER supposed to do real work in.  Take that to heart;  Do not use this for a system that you intend to do more than validate a script or an erlang snippet on.  It is not for more than that.  However, it does make for a rather handy way to do those irritating testing efforts just a little less irritating.

This project was created as a toy to use while learining Vagrant and has hown itself to be handy for me in general.

It uses very simple shell scripting for provisioning which should be easily converted to something else, should you not enjoy my choice of CentOS 6.7 as your base box.  It's a free country, fork and go wild.


The current environments that this project can create are:


#### Riak TS ####

 * riak-ts_1.5.0

#### Riak KV ####

* riak_1.4.12
* riak_2.0.0
* riak_2.0.7
* riak_2.1.4
* riak_2.2.0

#### Riak CS ####

 * riak-cs_2.1.0


#### Riak EE (if you bring your own EE RPMs) ####

 * riak-ee_2.0.7
 * riak-ee_2.1.4
 * riak-ee_2.2.0

> **Note:** There are other versions present in the Vagrantfile that can be uncommented should you desire to ues them.

### Use ###
```
vagrant up «environment name»
```
Will provision an environment.  RPMs will be downloaded once and cached in the **data/rpmcache** folder for reuse.


