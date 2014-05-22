mapr-singlenode-vagrant
=======================

A single node MapR cluster using Vagrant.

This project includes a Vagrant file that specifies a single VM suitable to run MapR, 
and ansible playbooks to perform the installation and initial configuration.

This will install MapR release 3.0.3, including hive and spark (and spark includes shark). This does not include a license, so to enable NFS and other licensed features, you'll need to obtain a license here: http://www.mapr.com/user/addcluster


Prerequisites
==============

You will want VirtualBox and Vagrant installed.

```
$ VirtualBox --help
Oracle VM VirtualBox Manager 4.3.8
```

```
$ vagrant --version
Vagrant 1.5.1
```

Pre-Install
============

1. Create a password for the mapr user. You'll use the mapr user to log into MCS. Use `openssl passwd -1` and put the hashed password in `playbooks/group_vars/all`.
2. Take a look at the rest of the variables in group_vars/all and override them as needed.
3. For each subdirectory of `roles`, there is a file `defaults/main.yml` which contains (you guessed it!) defaults for each role. It's worth a look at these to provide better, stronger passwords if you desire.  



Post-Install
============

After issuing `vagrant up`, the VM should be provisioned. Place your license key in the directory along side the Vagrantfile. In your Vagrant directory, say:

`vagrant ssh`

And you should be dropped into a shell in your VM.

If your license key is called demolicense.txt, the steps following will add the key, loopback mount MapR NFS, and create a volume for the vagrant user:

```
sudo maprcli license add -license /vagrant/demolicense.txt -is_file true
sudo maprcli node services -nodes node1 -nfs start
sudo mount -a -t nfs
sudo maprcli volume create -path /user/vagrant -name vagrant 
sudo chown vagrant:vagrant /mapr/`head /opt/mapr/conf/mapr-clusters.conf | awk -F " " '{print $1}'`/user/vagrant
```

To test, try running a teragen:

```
hadoop jar /opt/mapr/hadoop/hadoop-0.20.2/hadoop-0.20.2-dev-examples.jar \
	teragen 100000 /user/vagrant/teragen
```

If you don't see a java traceback, things are probably mostly OK.


