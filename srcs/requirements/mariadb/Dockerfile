FROM debian:bullseye

RUN apt update && apt install -y mariadb-server mariadb-client bash

COPY conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]