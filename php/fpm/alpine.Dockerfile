FROM alpine:3.8

ENV PHP_INI_DIR /etc/php7/

COPY ./start.sh /usr/local/bin/php-start

RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data \
    && chmod +x /usr/local/bin/php-start \
    && chown www-data:www-data /usr/local/bin/php-start \
    ; set -ex \
    && apk add --no-cache --update php7 \
        php7-fpm \
        php7-bcmath \
        php7-dom \
        php7-pdo \
        php7-pdo_pgsql \
        php7-openssl \
        php7-oauth \
        php7-imap \
        php7-mbstring \
        php7-pear \
        php7-session \
        php7-sockets \
        php7-intl \
        php7-tidy \
        php7-redis \
        php7-gd \
        php7-yaml \
        php7-tokenizer \
        php7-xml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-sodium \
        php7-phar \
        php7-opcache \
        php7-gettext \
        php7-iconv \
        php7-json \
        php7-curl \
        php7-ctype \
        php7-ftp \
        php7-zip \
    ; apk add --no-cache --update php7-dev \
    && apk add --no-cache --virtual .phpize_deps \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
		re2c \
        zlib-dev \
    && pecl install grpc \
    && pecl install protobuf \
    && echo "extension=grpc.so\nextension=protobuf.so\n" >> ${PHP_INI_DIR}/php.ini \
    && apk del --no-cache .phpize_deps \
    && apk del --no-cache php7-dev \
    && rm -Rrf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* ~/.pearrc \
    && mkdir -p /var/www/ \
    && chown www-data:www-data /var/www/

USER www-data:www-data

WORKDIR /var/www

ENTRYPOINT [ "php-start" ]
EXPOSE 9000
CMD [ "php-fpm" ]