-- Create the replica database
CREATE DATABASE repro_replica;
\c repro_replica
CREATE EXTENSION pglogical_origin;
CREATE EXTENSION pglogical;

-- Create the subscriber node
SELECT pglogical.create_node(
       node_name := 'repro_subscriber',
       dsn := 'dbname=repro_replica host=localhost port=5433'
);

\c repro_replica
SELECT pglogical.create_subscription(
       subscription_name := 'repro_subscription',
       provider_dsn := 'dbname=repro_primary host=localhost port=5434',
       synchronize_structure := TRUE
);
