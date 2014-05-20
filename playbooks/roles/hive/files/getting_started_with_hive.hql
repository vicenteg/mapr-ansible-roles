CREATE EXTERNAL TABLE IF NOT EXISTS web_log(viewTime INT, userid BIGINT, url STRING, referrer STRING, ip STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA LOCAL INPATH '/vagrant/sample-table.txt' INTO TABLE web_log;
SELECT web_log.* FROM web_log;
SELECT web_log.* FROM web_log WHERE web_log.url LIKE '%doc';
