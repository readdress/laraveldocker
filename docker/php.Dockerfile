FROM php:7.3-fpm-alpine

ARG user=www-data

WORKDIR /var/www

RUN apk update && apk add \
    build-base \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

RUN apk add autoconf \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && apk del autoconf

# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# RUN mkdir -p /home/$user/.composer && chown -R $user:$user /home/$user

COPY ./docker/php.ini /usr/local/etc/php/conf.d/local.ini 
COPY --chown=$user:$user . /var/www
# COPY --chown=$user:$user ./.env /var/www/.env

# RUN composer install
# RUN rm /usr/bin/composer

USER $user

RUN ["chmod", "+x", "./start_script.sh"]

EXPOSE 9000

CMD ./start_script.sh
