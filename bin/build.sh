#!/usr/bin/env bash

set -e

npm install
npm run build

# start db server
mkdir /data/db/
mongod --dbpath /data/db/

# migrate dbs
mongo birdAPI ./migration/mongo.provision.js
