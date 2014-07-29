mapr-hive
========

Installs the mapr-hive package, and performs some configuration.

Requirements
------------

This role configures MySQL databases, so it's assumed that there is a running instance of MySQL available.

Role Variables
--------------

The defaults will look something like this:

```
mysql_root_user: root
mysql_root_password: mapr

hive_db: metastore
hive_db_user: hive
hive_db_pass: mapr
hive_metastore_host: localhost

hive_version: "0.12*"
```

Modify as you see fit. By default, we'll use localhost for the database. Change the metastore host as needed to point to the correct MySQL server. The mysql_root_user and mysql_root_password variables will be used to authenticate to MySQL to create the metastore database.

Dependencies
------------

There is a MySQL playbook that installs and configures a mysql server: [](https://github.com/vicenteg/mapr-ansible-roles/tree/master/playbooks/roles/mysql-server)

Example Playbook
-------------------------

The example below assumes that an inventory file has been created with certain groups that can be used to identify the nodes in the cluster having certain roles.

```
---
- hosts: cldb:mysql:zookeepers
# just collecting facts so that we can locate the CLDB and mysql

- hosts: hiveserver
  sudo: yes
  roles:
    - mapr-client
    - mapr-hive
```

License
-------

BSD

Author Information
------------------

Vince Gonzalez - vgonzalez@mapr.com
