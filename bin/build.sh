#!/usr/bin/env bash

set -e

npm install
npm run build

# migrate dbs
npm run migrate
