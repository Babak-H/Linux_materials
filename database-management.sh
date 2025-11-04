#!/bin/bash

# i was running a SQL query on a linux node that connects to our postgres server, however the linux node got restarted, how can I find the process that is running the query on linux and see its rsults?

# If the Linux node was restarted, any running processes, including your query, would have been terminated. Unfortunately, this means that the query process itself is no longer running, and you 
# won't be able to directly retrieve its results from the terminated process. Check PostgreSQL Logs: PostgreSQL logs may contain information about the query that was running. Check the PostgreSQL 
# server logs to see if the query was logged before the node was restarted. The location of the logs can be found in the PostgreSQL configuration file (postgresql.conf) under the logdirectory and logfilename settings.
# Check Application Logs: If the query was initiated by an application, check the application's logs to see if the query and its results were logged there.
# Use a Transaction: In the future, consider running long or important queries within a transaction and logging the results or using a tool that can handle disconnections gracefully.

# but this node was not the server itself, it was only a cli terminal with connection to postgres server, was my query still aborted?

# If the Linux node that was acting as a client (CLI terminal) to connect to the PostgreSQL server was restarted, the connection to the PostgreSQL server would have been terminated. This means 
# that any query that was running from that client session would have been aborted unless it was running in a way that allowed it to continue independently on the server.
# Here’s what typically happens in such a scenario:
# 1. Client-Server Connection: When you run a query from a client (like a CLI terminal), the query is sent to the PostgreSQL server for execution. The client maintains a connection to the server to receive results.
# 2. Connection Termination: If the client node is restarted, the connection to the PostgreSQL server is lost. The server will detect this disconnection and will typically terminate any running queries associated with that session.
# 3. Query Abortion: As a result, the query that was running would be aborted by the PostgreSQL server because the client session was terminated.
# 4. Server-Side Operations: If the query was part of a larger transaction that was not committed, any changes made by the query would be rolled back.
# To handle such situations in the future, consider the following:
# Use Transactions: Wrap your queries in transactions to ensure atomicity. If a transaction is not committed, it will be rolled back automatically if the connection is lost.

sql
BEGIN;  -- Start the transaction
-- Your SQL query or queries
UPDATE employees SET salary = salary * 1.1 WHERE department = 'Sales';
COMMIT;  -- Commit the transaction to save changes


sql
BEGIN;  -- Start the transaction
-- Your SQL query or queries
UPDATE employees SET salary = salary * 1.1 WHERE department = 'Sales';
-- If something goes wrong or you need to cancel the changes
ROLLBACK;  -- Rollback the transaction to undo changes

# if i make a transaction and cli node gets restarted, the query will still continue?

# If you start a transaction and the client node (CLI) gets restarted, the transaction will not continue to execute on the PostgreSQL server. Instead, the transaction will be aborted, and any 
# uncommitted changes will be rolled back. This is because the connection between the client and the server is lost when the client node is restarted, and PostgreSQL will terminate any active transactions associated with that connection.
# Transaction Start: You begin a transaction and execute one or more queries.
# Connection Loss: If the client node is restarted, the connection to the PostgreSQL server is lost.
# Transaction Abortion: PostgreSQL detects the lost connection and automatically rolls back any active transactions associated with that session. This ensures that the database remains in a consistent state and that no partial changes are applied.
# No Continuation: The transaction does not continue to execute on the server because it relies on the client connection to manage the transaction state.

# To handle situations where you might lose the client connection, consider the following strategies: Background Processing: For long-running operations, consider using background processing or 
# job queues that can handle disconnections more gracefully. Use a Job Queue System:
# Job queue systems allow you to offload tasks to background workers. Popular job queue systems include: Celery, Sidekiq, Resque, RabbitMQ or Kafka
# Example with Celery (Python):

pip install celery
# python code
    from celery import Celery
    import psycopg2

    app = Celery('tasks', broker='redis://localhost:6379/0')

    @app.task
    def run_query():
        conn = psycopg2.connect("dbname=test user=postgres")
        cur = conn.cursor()
        cur.execute("SELECT * FROM my_table")
        results = cur.fetchall()
        conn.close()
        return results
    
    celery -A tasks worker --loglevel=info
    # Call the Task: From your application, you can call the task asynchronously.
    result = run_query.delay()


# how can I use pg_background extention to run my query?
# The pgbackground extension in PostgreSQL allows you to run queries in the background, which can be useful for offloading long-running tasks.

git clone https://github.com/vibhorkum/pg_background.git
cd pg_background
sudo make install

# sql code to use pg_background extension
CREATE EXTENSION pg_background;

# Start a Background Worker: Use the pgbackgroundlaunch function to start a background worker with your query.
# sql
SELECT pgbackgroundlaunch('SELECT * FROM my_table');
# Check the Status: You can check if the background query has completed using the pgbackgroundresult function.
SELECT * FROM pgbackgroundresult(handle);

# Retrieve Results: Once the query is complete, you can retrieve the results using the same pgbackgroundresult function.
# sql
SELECT pgbackgroundlaunch('SELECT * FROM my_table');
-- Assume the handle returned is '12345'
SELECT * FROM pgbackgroundresult('12345');


# postgres table vaccuming => In PostgreSQL, table vacuuming is a maintenance operation that helps manage storage and improve database performance. The process involves cleaning up dead tuples (obsolete rows) 
# that result from updates and deletes.
# 1. MVCC (Multi-Version Concurrency Control): PostgreSQL uses MVCC to handle concurrent transactions. When a row is updated or deleted, the old version of the row is not immediately removed. 
# Instead, a new version of the row is created, and the old version is marked as obsolete or "dead." This allows other transactions to continue accessing the old version until they are completed.
# 2. Dead Tuples: Over time, as updates and deletes occur, the number of dead tuples in a table can increase. These dead tuples consume storage space and can lead to inefficient use of resources, 
# as they still need to be scanned during certain operations.
# 3. Vacuuming: The 'VACUUM' command is used to reclaim storage occupied by dead tuples. It marks the space occupied by these tuples as available for future use, effectively cleaning up the 
# table. Vacuuming also helps update the visibility map, which can improve the efficiency of index-only scans.
# Regular vacuuming is essential for maintaining the health and performance of a PostgreSQL database, especially in environments with frequent updates and deletes.
# basic vaccum
VACUUM;
# Vacuum a Specific Table
VACUUM my_table;
# vaccum with analyze => ANALYZE option updates the statistics used by the PostgreSQL query planner, which can help improve query performance. This command vacuums and analyzes a specific table
VACUUM ANALYZE my_table;
# vaccum full => The FULL option reclaims more space by compacting the table, but it requires an exclusive lock on the table. Use this option with caution, as it can impact performance
VACUUM FULL my_table;


# What is the format for the PostgreSQL connection string / URL?
postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]

postgresql://
postgresql://localhost
postgresql://localhost:5432
postgresql://localhost/mydb
postgresql://user@localhost
postgresql://user:secret@localhost
postgresql://other@localhost/otherdb?connect_timeout=10&application_name=myapp
postgresql://localhost/mydb?user=other&password=secret

"postgres://YourUserName:YourPassword@YourHostname:5432/YourDatabaseName"
postgres://postgress:PASSWORD@db-1020-0ie-core-cnn-vt-cluster:5432


SHOW GRANTS ON DATABASE "ht-restore";
GRANT ALL ON TABLE "ht-restore".v_kv_store TO hault;
SHOW GRANTS ON DATABASE "ht-restore".v_kv_store;

SHOW USERS;
CREATE USER test_1 WITH LOGIN PASSWORD '$tr0nGpassW0rD' VALID UNTIL '2021-10-10';
CREATE USER test_2 WITH PASSWORD NULL;

REVOKE CREATE,INSERT,UPDATE ON test.customers FROM test_user;
DROP USER test_user;

DROP EXTENSION IF EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;


psql -h $DB_HOST -U $DB_USERNAME -c "ALTER USER vault_admin WITH PASSWORD '$DB_NEWPASS';"
psql -X -A -h $DB_HOST -U $DB_USERNAME -t -c "SELECT 1 FROM pg_catalog.pg_roles WHERE rolname='vt_admin';"
# -X → Disables reading the .psqlrc file (which contains user-specific configurations).
# -A → Enables unaligned output format (removes extra spaces, making output easier to parse in scripts).
# -h $DB_HOST → Specifies the database host ($DB_HOST is a variable holding the hostname).
# -U $DB_USERNAME → Specifies the database user ($DB_USERNAME is a variable for the username).
# -t → Removes headers and extra formatting from the output (useful when scripting).
# -c "<SQL_QUERY>" → Executes the provided SQL command.

# pg_catalog.pg_roles → A system catalog table in PostgreSQL that stores information about roles (users and groups).
# WHERE rolname='vt_admin' → Filters the result to check if a role named 'vt_admin' exists.

psql -h $DB_HOST -U $DB_USERNAME -c "GRANT rds_superuser TO vault_admin;"
