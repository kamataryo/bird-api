#!/usr/bin/env bash

set -e

npm install
npm run build

# start db server
sudo mkdir /data
sudo mkdir data/db
sudo mongod --dbpath ~/data/db

# migrate dbs
mongo birdAPI ./migration/mongo.provision.js
