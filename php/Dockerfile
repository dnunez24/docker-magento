FROM php:5.4-fpm
MAINTAINER Dave Nunez <dnunez24@gmail.com>
RUN apt-get -qqy update \
  && apt-get -qqy install \
    libcurl3-dev \
    libfreetype6 \
    libfreetype6-dev \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libmcrypt4 \
    libmcrypt-dev \
    libpng12-dev \
    libxml2-dev \
    libxslt-dev \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
  && pecl install ZendOpcache \
  && docker-php-ext-install \
    curl \
    bcmath \
    gd \
    mbstring \
    mcrypt \
    pdo_mysql \
    soap \
    xsl \
    zip \
  && apt-get purge --auto-remove -y \
    libcurl3-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxml2-dev \
    libxslt-dev
COPY php-fpm.conf /etc/php5/fpm/php-fpm.conf
COPY magento.conf /etc/php5/fpm/pool.d/magento.conf
COPY xdebug.ini /etc/php5/fpm/conf.d/xdebug.ini
CMD ["/usr/local/sbin/php-fpm", "-y", "/etc/php5/fpm/php-fpm.conf"]
