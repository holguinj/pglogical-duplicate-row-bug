(ns repro-clj.core
  (:require [clojure.java.jdbc :as jdbc])
  (:import [java.util UUID])
  (:gen-class))

(def db
  {:classname "org.postgresql.Driver"
   :subprotocol "postgresql"
   :subname "//localhost:5434/repro_primary"
   :user "postgres"})

(defn setup-db [db]
  (jdbc/execute! db ["DROP TABLE IF EXISTS example CASCADE"])
  (jdbc/execute! db ["CREATE TABLE example (
                        id UUID PRIMARY KEY,
                        last_active TIMESTAMPTZ DEFAULT now()
                        )"])
  (jdbc/query db ["SELECT pglogical.replication_set_add_table('default', 'example', TRUE)"]))

(defn update-row [db id]
  (jdbc/execute! db ["UPDATE example
                        SET last_active = now()
                        WHERE id = ?"
                     id]))

(defn insert-rows
  "Returns a vector of the UUID keys"
  [db num-rows]
  (let [uuids (->> (repeatedly #(UUID/randomUUID))
                   (take num-rows)
                   vec)
        rows (map (partial hash-map :id) uuids)]
    (jdbc/insert-multi! db :example rows)
    uuids))

(defn -main
  [& args]
  (let [n 100000]
    (println "Setting up database...")
    (setup-db db)
    (println "Inserting" n "rows...")
    (let [ids (insert-rows db n)]
      (println "Continuously updating random rows...")
      (println "Run the subscribe.sh script now.")
      (loop []
        (update-row db (rand-nth ids))
        (recur)))))
