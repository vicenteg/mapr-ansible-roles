sparkmaster
========

Installs a Spark master.

Requirements
------------

This role assumes that the MapR apt/yum repositories have been configured.

Role Variables
--------------

`default/main.yml` contains the following:

```
spark_version: 0.9.1
spark_home: /opt/mapr/spark/spark-{{spark_version}}
```

There's not currently a need to modify these.

Dependencies
------------

mapr-prerequisites


Example Playbook
-------------------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: sparkmasters
      roles:
         - { role: mapr-spark-master, spark_version: "0.9.1" }


Post-Install
--------------

Try out a few spark applications:

1. Shark

```
sudo -u mapr /opt/mapr/shark/shark-0.9.0/bin/shark --service sharkserver2 &
sudo -u mapr /opt/mapr/shark/shark-0.9.0/bin/shark --service beeline
```

Once in beeline:

```
beeline> show tables;
No current connection
beeline> !connect jdbc:hive2://localhost:10000 mapr foobar org.apache.hive.jdbc.HiveDriver
Connecting to jdbc:hive2://localhost:10000
Connected to: Hive (version 0.11.0-shark-0.9.1)
Driver: Hive (version 0.11.0-shark-0.9.1)
Transaction isolation: TRANSACTION_REPEATABLE_READ
0: jdbc:hive2://localhost:10000>
```

Try creating a table:

```
CREATE TABLE pokes (foo INT, bar STRING);
LOAD DATA LOCAL INPATH '/opt/mapr/hive/hive-0.12/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;
SELECT * FROM pokes;
```

You should see some output like:

```
0: jdbc:hive2://localhost:10000> CREATE TABLE pokes (foo INT, bar STRING);
No rows affected (0.173 seconds)
0: jdbc:hive2://localhost:10000> LOAD DATA LOCAL INPATH '/opt/mapr/hive/hive-0.12/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;
No rows affected (0.736 seconds)
0: jdbc:hive2://localhost:10000> SELECT * FROM pokes;
+------+----------+
| foo  |   bar    |
+------+----------+
| 389  | val_389  |
| 327  | val_327  |
| 242  | val_242  |
| 369  | val_369  |
| 392  | val_392  |
| 272  | val_272  |
| 331  | val_331  |
| 401  | val_401  |
...
```



License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
