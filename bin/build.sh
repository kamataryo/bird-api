#!/usr/bin/env bash

set -e

npm install
npm run build

# start db server
mkdir ~/mongodb
mongod --dbpath ~/mongodb

# migrate dbs
npm run migrate
