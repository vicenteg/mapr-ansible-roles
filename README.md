mapr-singlenode-vagrant
=======================

A single node MapR cluster using Vagrant.

This project includes a Vagrant file that specifies a single VM suitable to run MapR, 
and ansible playbooks to perform the installation and initial configuration.

Prerequisites
==============

You will want VirtualBox and Vagrant installed.

`
$ VirtualBox --help
Oracle VM VirtualBox Manager 4.3.8
`

`
$ vagrant --version
Vagrant 1.5.1
`

Post-Install
============

After issuing `vagrant up`, the VM should be provisioned. Place your license key in the directory along side the Vagrantfile. In your Vagrant directory, say:

`vagrant ssh`

And you should be dropped into a shell in your VM.

If your license key is called demolicense.txt, the steps following will add the key, loopback mount MapR NFS, and create a volume for the vagrant user:

`
sudo maprcli license add -license /vagrant/demolicense.txt -is_file true
sudo maprcli node services -nodes node1 -nfs start
sudo mount -a -t nfs
sudo maprcli volume create -path /user/vagrant -name vagrant 
sudo chown vagrant:vagrant /mapr/<clustername>/user/vagrant
`

To test, try running a teragen:

`
hadoop jar /opt/mapr/hadoop/hadoop-0.20.2/hadoop-0.20.2-dev-examples.jar teragen 100000 /user/vagrant/teragen
`

If you don't see a java traceback, things are probably mostly OK.


