#!/usr/bin/env bash

cd /var/www/ghost
NODE_ENV=production ./node_modules/.bin/knex-migrator init
NODE_ENV=production node index.js