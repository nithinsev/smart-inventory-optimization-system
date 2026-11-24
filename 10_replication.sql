USE smart_inventory;

SELECT
    VERSION() AS mysql_version,
    @@hostname AS server_name,
    @@port AS server_port,
    @@server_id AS server_id;
    
SHOW VARIABLES LIKE 'log_bin';

SHOW VARIABLES LIKE 'binlog_format';

SHOW VARIABLES LIKE 'binlog_expire_logs_seconds';

SHOW VARIABLES LIKE 'server_id';

SHOW BINARY LOGS;

SHOW MASTER STATUS;

SHOW REPLICA STATUS;