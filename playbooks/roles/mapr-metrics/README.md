Role Name
========

Installation of MapR metrics.

Requirements
------------

This playbook installs the MapR metrics package. This places metrics on hosts that are part of the webserver and jobtracker nodes.

Role Variables
--------------

The defaults are as follows. The metrics_host variable uses groups, and selects the first node tagged as a MySQL server. Change these as needed.

```
metrics_user: maprmetrics
metrics_password: mapr
metrics_host: "{{ groups['mysql'] | first }}"
```

Dependencies
------------

None

Example Playbook
-------------------------

```
---
- hosts: webserver:jobtracker
  sudo: yes
  roles:
    - mapr-metrics
```

License
-------

BSD