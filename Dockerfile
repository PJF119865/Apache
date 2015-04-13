FROM phusion/baseimage:0.9.15
MAINTAINER Peter <peter_f_@hotmail.com>

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOME            /root
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

# Install base packages
RUN apt-get update && \
apt-get -yq install \
curl \
apache2 \
libapache2-mod-php5 \
php5-mysql \
php5-gd \
php5-curl \
php-pear \
php-apc && \
rm -rf /var/lib/apt/lists/* && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh
# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD sample/ /app
EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
