FROM php:7.2-fpm

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

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
    && { \
        echo "[opcache]"; \
        echo "opcache.enable=1"; \
        echo "opcache.revalidate_freq=0"; \
        echo "opcache.validate_timestamps=${PHP_OPCACHE_VALIDATE_TIMESTAMPS}"; \
        echo "opcache.max_accelerated_files=${PHP_OPCACHE_MAX_ACCELERATED_FILES}"; \
        echo "opcache.memory_consumption=${PHP_OPCACHE_MEMORY_CONSUMPTION}"; \
        echo "opcache.max_wasted_percentage=${PHP_OPCACHE_MAX_WASTED_PERCENTAGE}"; \
        echo "opcache.interned_strings_buffer=16"; \
        echo "opcache.fast_shutdown=1"; \
    } | tee /usr/local/etc/php/conf.d/opcache.ini \
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

EXPOSE 9000

CMD ["php-fpm"]
