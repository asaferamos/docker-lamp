FROM php:7.1-apache

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ \
    curl \
    libmemcached-dev \
    libpq-dev \
    libfreetype6-dev \
    libpng-dev \
    libmcrypt-dev \
    libjpeg62-turbo-dev \
    curl \
    git \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pecl install memcached
RUN docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-install soap \
    && docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        mcrypt \
        mysqli \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        sockets \
        zip \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

COPY run-lamp.sh /usr/sbin/

RUN a2enmod rewrite
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin \
    --filename=composer

RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
RUN /./opt/letsencrypt/letsencrypt-auto --install-only

# @TODO
# habilitar o mod_ssl do apache
# copiar o /opt/letsencrypt/certbot-apache/certbot_apache/options-ssl-apache.conf  para /etc/letsencrypt

CMD ["/usr/sbin/run-lamp.sh"]
