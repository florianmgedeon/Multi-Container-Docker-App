FROM debian:bullseye

RUN apt update && apt install -y \
    php-fpm \
    php-mysql php-json php-curl php-gd php-mbstring php-xml php-tokenizer php-opcache php-zip \
    mariadb-client bash curl ca-certificates tar unzip \
    --no-install-recommends && \
    apt purge -y apache2 apache2-utils apache2-bin apache2-data && \
    apt autoremove -y && apt clean

RUN echo "clear_env = no" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[DOMAIN_NAME] = \$DOMAIN_NAME" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[MYSQL_DATABASE] = \$MYSQL_DATABASE" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[MYSQL_USER] = \$MYSQL_USER" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[MYSQL_HOST] = \$MYSQL_HOST" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[WP_ADMIN_USER] = \$WP_ADMIN_USER" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[WP_USER] = \$WP_USER" >> /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 9000

RUN mkdir -p /run/php && \
    sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT ["/init.sh"]
