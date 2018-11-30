FROM alpine:3.8

ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
		re2c

ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
ENV GPG_KEYS 1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F
ENV PHP_VERSION 7.2.12
ENV PHP_URL="https://secure.php.net/get/php-7.2.12.tar.xz/from/this/mirror" PHP_ASC_URL="https://secure.php.net/get/php-7.2.12.tar.xz.asc/from/this/mirror"
ENV PHP_SHA256="989c04cc879ee71a5e1131db867f3c5102f1f7565f805e2bb8bde33f93147fe1" PHP_MD5=""

COPY docker-php-source docker-php-ext-* docker-php-entrypoint /usr/local/bin/

RUN apk add --no-cache --virtual .persistent-deps \
		ca-certificates \
		curl \
		tar \
		xz \
		libressl \
    && set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data \
    && mkdir -p $PHP_INI_DIR/conf.d \
    && set -xe; \
        \
        apk add --no-cache --virtual .fetch-deps \
            gnupg \
            wget \
        ; \
        \
        mkdir -p /usr/src; \
        cd /usr/src; \
        \
        wget -O php.tar.xz "$PHP_URL"; \
        \
        if [ -n "$PHP_SHA256" ]; then \
            echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
        fi; \
        if [ -n "$PHP_MD5" ]; then \
            echo "$PHP_MD5 *php.tar.xz" | md5sum -c -; \
        fi; \
        \
        if [ -n "$PHP_ASC_URL" ]; then \
            wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
            export GNUPGHOME="$(mktemp -d)"; \
            for key in $GPG_KEYS; do \
                gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
            done; \
            gpg --batch --verify php.tar.xz.asc php.tar.xz; \
            command -v gpgconf > /dev/null && gpgconf --kill all; \
            rm -rf "$GNUPGHOME"; \
        fi; \
        \
        apk del .fetch-deps \
    && set -xe \
	&& apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		argon2-dev \
		coreutils \
		curl-dev \
		libedit-dev \
		libressl-dev \
		libsodium-dev \
		libxml2-dev \
	\
	&& export CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
	&& docker-php-source extract \
	&& cd /usr/src/php \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		\
		--enable-option-checking=fatal \
		\
		--with-mhash \
		\
		--enable-ftp \
		--enable-mbstring \
		--with-password-argon2 \
		--with-sodium=shared \
		\
		--with-curl \
		--with-libedit \
		--with-openssl \
		--with-zlib \
        --with-pgsql \
		\
		$(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
		\
		$PHP_EXTRA_CONFIGURE_ARGS \
	&& make -j "$(nproc)" \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
	&& make clean \
	\
	&& cp -v php.ini-* "$PHP_INI_DIR/" \
	\
    && cp "$PHP_INI_DIR/php.ini.production" "$PHP_INI_DIR/php.ini" \
    \
	&& cd / \
	&& docker-php-source delete \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --no-cache --virtual .php-rundeps $runDeps

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    \
	&& pecl update-channels \
	&& rm -rf /tmp/pear ~/.pearrc \
    && docker-php-ext-configure intl \
    && docker-php-ext-install hash intl mbstring opcache pdo_pgsql pgsql zip \
    && pecl install memcached redis grpc protobuf imagick \
    && docker-php-ext-enable memcached.so redis.so grpc.so protobuf.so imagick.so \
    && docker-php-ext-enable sodium hash intl mbstring opcache pdo_pgsql pgsql zip \
    \
	&& apk del .build-deps \
	\
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

RUN set -ex \
	&& cd /usr/local/etc \
	&& if [ -d php-fpm.d ]; then \
		# for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
		sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
	else \
		# PHP 5.x doesn't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
		mkdir php-fpm.d; \
		cp php-fpm.conf.default php-fpm.d/www.conf; \
		{ \
			echo '[global]'; \
			echo 'include=etc/php-fpm.d/*.conf'; \
		} | tee php-fpm.conf; \
	fi \
	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee php-fpm.d/docker.conf \
	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = 9000'; \
	} | tee php-fpm.d/zz-docker.conf

ENTRYPOINT ["docker-php-entrypoint"]
WORKDIR /var/www/

EXPOSE 9000

CMD ["php-fpm"]
