FROM php:7.2-apache

RUN apt-get update \
    ; apt-get install -y --no-install-recommends libbz2-dev \
    && docker-php-ext-install bz2 \
    ; docker-php-ext-install bcmath \
    ; docker-php-ext-install exif \
    ; apt-get install -y --no-install-recommends libpng-dev libjpeg-dev libwebp-dev libxpm-dev \
    && docker-php-ext-configure gd --with-webp-dir=DIR --with-jpeg-dir=DIR --with-png-dir=DIR --with-xpm-dir=DIR \
    && docker-php-ext-install gd \
    ; docker-php-ext-install gettext \
    ; apt-get install -y --no-install-recommends libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    ; apt-get install -y --no-install-recommends libpq-dev \
    && docker-php-ext-configure pdo_pgsql \
    && docker-php-ext-install pdo_pgsql \
    ; docker-php-ext-install sockets \
    ; apt-get install -y --no-install-recommends libtidy-dev \
    && docker-php-ext-configure tidy \
    ; docker-php-ext-install tidy \
    && docker-php-ext-install zip \
    ; docker-php-ext-configure opcache \
    && docker-php-ext-install opcache \
    ; pecl update-channels \
    ; pecl install protobuf grpc \
    && echo "extension=protobuf.so" >> /usr/local/etc/php/conf.d/php-ext-protobuf.ini \
    && echo "extension=grpc.so" >> /usr/local/etc/php/conf.d/php-ext-grpc.ini \
    ; pecl clear-cache \
    ; rm -rf /tmp/pear ~/.pearrc \
    ; rm -rf /var/lib/apt/lists/* \
    ; apt-get autoremove && apt-get autoclean \
    ; apt-mark auto '.*' > /dev/null \
    ; [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark \
    ; find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
    ; apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
