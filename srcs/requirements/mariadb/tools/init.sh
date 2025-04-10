#!/bin/bash

set -e

MARKER_FILE="/var/lib/mysql/.setup_done"
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
rm -f /run/mysqld/mysqld.sock /var/lib/mysql/mysqld.pid

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}

if [ ! -f "$MARKER_FILE" ]; then
    echo "🆕 New MariaDB setup"

    echo "▶️ Installing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    echo "✅ Step 1: Install done"

    echo "▶️ Starting temporary MariaDB (without networking)..."
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    TEMP_PID=$!

    echo "⏳ Waiting for temporary MariaDB to start..."
    until mysqladmin ping --silent; do
        sleep 1
    done
    echo "✅ Step 2: MariaDB started"

    echo "🔐 Setting root password (local only)..."
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    echo "✅ Step 3: Root password set"

    echo "🛠️ Creating database and user..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL
    echo "✅ Step 4: Database and user created"

    echo "🛑 Shutting down temporary MariaDB..."
    mysqladmin shutdown -u root -p"${MYSQL_ROOT_PASSWORD}"
    wait "$TEMP_PID"
    echo "✅ Step 5: Shutdown complete"

    touch "$MARKER_FILE"
fi

echo "🚀 Starting MariaDB in foreground..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
