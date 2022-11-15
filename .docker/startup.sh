#!/bin/bash

# tells the bash script to exit whenever anything returns a non-zero return value.
set -e

# crude way to wait for database container to be ready
echo "Please wait while we allow for the database continer start..."
sleep 20

# will check current database schema version. First time, this will throw an
# error in the server logs because the database will not exist. After the error,
# the database will be created, the schema will be loaded and seeded.
rails db:version || bundle exec rails db:setup

# run migrations
rails db:migrate

exec bundle exec rackup -E $RAILS_ENV -p 3000 -o 0.0.0.0
