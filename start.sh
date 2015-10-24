#!/bin/bash

/usr/bin/mysqld_safe &
sleep 5s

# piwik directory authority
chmod a+w /www/piwik/config /www/piwik/tmp
chown -R www-data:www-data /www/piwik

MYSQL_PASSWORD=`pwgen -cyn -1 12`
PIWIK_PASSWORD=`pwgen -cyn -1 12`

echo ">>> Generate MySQL root password: ${MYSQL_PASSWORD}"
echo ">>> Generate user 'piwik'\'s password of MySQL: ${PIWIK_PASSWORD}"
echo $MYSQL_PASSWORD > /mysqlpwd.txt
echo $PIWIK_PASSWORD > /piwikpwd.txt

# MySQL configuration follow:
echo ">>> Configurate mysql server..."
mysqladmin -u root password $MYSQL_PASSWORD

# https://piwik.org/docs/requirements/
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE piwik;"
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE USER 'piwik'@'localhost' IDENTIFIED BY '${PIWIK_PASSWORD}';"
mysql -uroot -p$MYSQL_PASSWORD -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON piwik.* TO 'piwik'@'localhost';"
echo ">>> Done."

echo ">>> Start php5-fpm..."
service php5-fpm start
echo ">>> Done."

echo ">>> Start Nginx..."
service nginx start
echo ">>> Done."

tail -f