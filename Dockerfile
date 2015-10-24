FROM ubuntu:latest
MAINTAINER Micooz <micooz@hotmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get --yes upgrade

# Basic requirements
RUN apt-get install --yes vim pwgen unzip wget

# Web server Nginx
RUN apt-get install --yes nginx

# PHP requirements
# Follow: https://piwik.org/docs/requirements/
RUN apt-get install --yes php5-fpm php5-curl php5-gd php5-cli php5-geoip

# MySQL requirements
RUN apt-get install --yes mysql-server php5-mysql

# Installtion of piwik
# https://piwik.org/docs/installation/#start-the-installation
RUN mkdir /www
WORKDIR /www
  RUN wget --force-directories http://builds.piwik.org/piwik.zip
  RUN mv builds.piwik.org/piwik.zip piwik.zip
  RUN rm -r builds.piwik.org
  RUN unzip -q piwik.zip
WORKDIR /

# mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini

# Nginx config
ADD site.conf /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 755 /start.sh

VOLUME /www

CMD /bin/bash /start.sh