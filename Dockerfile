FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential apt-transport-https ca-certificates curl software-properties-common make unzip perl
RUN apt-get install -y libxslt1-dev libxml2-dev python-dev libgd-dev libgeoip-dev libxslt-dev libxml2-dev libperl-dev libpcre3 libpcre3-dev libssl-dev libreadline-dev libncurses5-dev

# Install PHP
RUN add-apt-repository -y ppa:ondrej/php && apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    php7.3-fpm php7.3-cli php7.3-mysql php7.3-gd php7.3-imagick php7.3-recode php7.3-tidy php7.3-xmlrpc php7.3-common php7.3-curl php7.3-mbstring php7.3-xml php7.3-bcmath php7.3-bz2 php7.3-intl php7.3-json php7.3-readline php7.3-zip php7.3-soap

# Modify PHP config
RUN sed -i 's/memory_limit\s*=.*/memory_limit=256M/g' /etc/php/7.3/apache2/php.ini
RUN sed -i 's/max_execution_time\s*=.*/max_execution_time=360/g' /etc/php/7.3/apache2/php.ini
RUN sed -i 's/post_max_size\s*=.*/post_max_size=200M/g' /etc/php/7.3/apache2/php.ini
RUN sed -i 's/upload_max_filesize\s*=.*/uplaod_max_filesize=200M/g' /etc/php/7.3/apache2/php.ini
RUN sed -i 's/allow_url_fopen\s*=.*/allow_url_fopen=On/g' /etc/php/7.3/apache2/php.ini

# Install Apache
RUN add-apt-repository -y ppa:ondrej/apache2 && apt update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 apache2-utils libapache2-mod-php7.3 libapache2-mod-php libapache2-mod-wsgi

# Enable Apache mods
RUN a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod proxy_ajp && \
    a2enmod rewrite && \
    a2enmod deflate && \
    a2enmod headers && \
    a2enmod proxy_balancer && \
    a2enmod proxy_connect && \
    a2enmod ssl && \
    a2enmod cache && \
    a2enmod expires && \
    chmod g+w /var/log/apache2 && \
    chmod 777 /var/lock/apache2 && \
    chmod 777 /var/run/apache2

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
