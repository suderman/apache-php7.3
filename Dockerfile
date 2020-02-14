FROM debian:latest

ARG PHP_VERSION=7.3
# RUN apt-get update && apt-get upgrade -y
# RUN apt-get install -y build-essential apt-transport-https ca-certificates curl software-properties-common make unzip perl
# RUN apt-get install -y bindfs libxslt1-dev libxml2-dev python-dev libgd-dev libgeoip-dev libxslt-dev libxml2-dev libperl-dev libpcre3 libpcre3-dev libssl-dev libreadline-dev libncurses5-dev

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
      apt-transport-https \
      bindfs \
      build-essential \
      ca-certificates \
      curl \
      less \
      libgd-dev \
      libgeoip-dev \
      libncurses5-dev \
      libpcre3 \
      libpcre3-dev \
      libperl-dev \
      libreadline-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      libxslt1-dev \
      make \
      perl \
      python-dev \
      software-properties-common \
      unzip \
      vim \
      wget \

# Install MySQL Client
RUN cd /tmp && \
      curl https://repo.mysql.com//mysql-apt-config_0.8.14-1_all.deb > mysql.deb && \
      dpkg -i mysql.deb && \
      apt update && \
      apt -y install mysql-client

# Install PHP
RUN apt update && apt install -y \
      php \
      php-bcmath \
      php-cli \
      php-common \
      php-curl \
      php-fpm \
      php-gd \
      php-json \
      php-mbstring \
      php-mysql \
      php-pdo \
      php-pear \
      php-xml \
      php-zip \

# Install Apache
RUN apt update && apt install -y libapache2-mod-php

# Enable Apache mods
RUN a2enmod php${PHP_VERSION} && \
    a2enmod cache && \
    a2enmod deflate && \
    a2enmod expires && \
    a2enmod headers && \
    a2enmod proxy && \
    a2enmod proxy_ajp && \
    a2enmod proxy_balancer && \ 
    a2enmod proxy_connect && \
    a2enmod proxy_http && \
    a2enmod rewrite && \
    a2enmod ssl && \
    chmod g+w /var/log/apache2 && \
    chmod 777 /var/lock/apache2 && \
    chmod 777 /var/run/apache2

# Modify Apache config
# RUN cd /etc/apache2 && \
#       sed -i 's/<Directory\ \/var\/www\/>/<Directory\ \/tmp\/var\/www\/>/g' apache2.conf 
RUN cd /etc/apache2 && \
      echo "ServerName localhost" >> apache2.conf

# Modify PHP config
RUN cd /etc/php/${PHP_VERSION}/apache2 && \
      sed -i 's/memory_limit\s*=.*/memory_limit=256M/g' php.ini && \
      sed -i 's/max_execution_time\s*=.*/max_execution_time=360/g' php.ini && \
      sed -i 's/post_max_size\s*=.*/post_max_size=200M/g' php.ini && \
      sed -i 's/upload_max_filesize\s*=.*/upload_max_filesize=200M/g' php.ini && \
      sed -i 's/allow_url_fopen\s*=.*/allow_url_fopen=On/g' php.ini

EXPOSE 80

ADD ./run.sh /run.sh
RUN chmod +x /run.sh

CMD /run.sh
