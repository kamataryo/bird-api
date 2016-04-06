#!/usr/bin/env bash

set -e

npm install
npm run build

# start db server
mongod --dbpath /usr/local/var/mongodb/

# migrate dbs
mongo birdAPI ./migration/mongo.provision.js