-- Create the primary DB
CREATE DATABASE repro_primary;
\c repro_primary
CREATE EXTENSION pglogical_origin;
CREATE EXTENSION pglogical;

-- Create the provider node
SELECT pglogical.create_node(
       node_name := 'repro_provider',
       dsn := 'dbname=repro_primary host=primary port=5432'
);

-- Smoke table

CREATE TABLE smoke (id INT PRIMARY KEY, msg TEXT);
INSERT INTO smoke (id, msg) VALUES(0, 'hello');
SELECT pglogical.replication_set_add_table('default', 'smoke', TRUE);
