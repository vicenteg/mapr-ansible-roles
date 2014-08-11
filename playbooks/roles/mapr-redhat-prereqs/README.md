Role Name
========

This playbook configures nodes per http://doc.mapr.com/display/MapR/Preparing+Each+Node


Requirements
------------

This role expects to be able to install some packages from standard CentOS or
RedHat repositories, so the node should be configured to allow access to an
internal or external CentOS/RedHat repository.

Role Variables
--------------

A description of the settable variables for this role should go here,
including any variables that are in defaults/main.yml, vars/main.yml, and any
variables that can/should be set via parameters to the role. Any variables
that are read from other roles and/or the global scope (ie. hostvars, group
vars, etc.) should be mentioned here as well.

The following variables are set by default. The password should minimally be
overridden by setting it in `vars/main.yml`.

```
mapr_user_pw: '$1$yoPLWBQ6$6fvQchDTBu3Ccs3PVURpA.'

mapr_uid: 2147483632
mapr_gid: 2147483632
mapr_home: /home/mapr
```

Dependencies
------------

None

Example Playbook
-------------------------

- hosts: all
  tasks:
    - group_by: key={{ansible_virtualization_type}}
    - group_by: key={{ansible_distribution}}

- hosts: CentOS;RedHat
  max_fail_percentage: 0
  sudo: yes
  roles:
    - mapr-redhat-prereqs

License
-------

BSD

