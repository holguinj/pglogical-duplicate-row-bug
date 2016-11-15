-- Create the replica database
CREATE DATABASE repro_replica;
\c repro_replica
CREATE EXTENSION pglogical_origin;
CREATE EXTENSION pglogical;

-- Create the subscriber node
SELECT pg_sleep(5); -- make sure the primary starts first
SELECT pglogical.create_node(
       node_name := 'repro_subscriber',
       dsn := 'dbname=repro_replica host=replica port=5432'
);
