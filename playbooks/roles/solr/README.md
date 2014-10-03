Role Name
=========

This is a role for installing Apache Solr on MapR Hadoop.

Requirements
------------

MapR Hadoop should be installed already on the cluster. 

Role Variables
--------------

Dependencies
------------


Example Playbook
----------------

    - hosts: solr
      roles:
         - { role: solr }

License
-------

BSD

Author Information
------------------

Vince Gonzalez - <vgonzalez@mapr.com>
