#!/bin/sh

# Exit on error
set -e

# Check if mysql is installed
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "Already initialized."
else
    echo "Initializing..."

    # Start mysqld
    mysqld --user=root --datadir=./data & ./loading_database.sh
    echo "Starting..."
    while [ true ]; do
      true
    done
fi
