FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD stepzen-dev
ADD boostrap.sql /docker-entrypoint-initdb.d

EXPOSE 3306