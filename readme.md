# possible pglogical bug reproduction attempt

## background

We had thought that there was an issue with pglogical where rows could be replicated twice during initial sync, probably when a row was being updated during the sync process.

This repo attempts to recreate that situation to see if the behavior arises.

## requirements

Docker, docker-compose, leiningen.

## high-level plan

This repo is designed to carry out the following:
  1. Set up two databases, primary and replica, with replication initially disabled.
  2. On the primary, create a large and constantly changing table with a unique key constraint.
  3. While that table is being updated, begin a replication subscription.
  4. Check for errors in the logs.

## steps

* run `docker-compose up` to bring up the primary (pg port 5434) and replica (pg port 5433) containers.
* once they've started, run `cd repro-clj && lein run` to begin hitting the DB
* when repro-clj tells you to, run `./subscribe.sh` to begin the subscription
* check for error logs on the primary and replica containers

Optionally, you can connect to the primary or replica with psql using the following commands:

```
# primary:
psql -h localhost -p 5434 -U postgres repro_primary

# replica:
psql -h localhost -p 5433 -U postgres repro_replica
```

## results

Nothing interesting. Everything works as it should, which is to say that this fails to replicate the bug.
