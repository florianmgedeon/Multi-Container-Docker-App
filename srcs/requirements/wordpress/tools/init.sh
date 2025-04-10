#!/bin/bash

set -e

WP_ADMIN_PASSWORD=$(cat /run/secrets/admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/user_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

echo "Waiting for MySQL at mariadb"
until mysqladmin --silent ping -h"mariadb"; do
    echo "Waiting for MySQL to be ready..."
    sleep 2
done

#download & create wp files
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Downloading WordPress core"
    wp core download --allow-root

    echo "Creating wp-config.php"
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --url="$DOMAIN_NAME" \
        --skip-check \
        --allow-root

    echo "Setting secret keys and salts"
    for KEY in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT; do
        VALUE=$(grep "^$KEY=" /run/secrets/wp_secrets | cut -d '=' -f2-)
        wp config set $KEY "$VALUE" --allow-root
    done

    echo "Forcing HTTPS site URL"
    wp config set WP_HOME "https://$DOMAIN_NAME" --allow-root
    wp config set WP_SITEURL "https://$DOMAIN_NAME" --allow-root

fi

#install wp
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress"
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="admin@example.com" \
        --allow-root

    echo "Creating additional user"
    wp user create "$WP_USER" user@example.com --role=subscriber --user_pass="$WP_USER_PASSWORD" --allow-root
fi

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM"
exec php-fpm7.4 -F
