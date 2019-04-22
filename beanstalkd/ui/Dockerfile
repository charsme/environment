FROM charsme/environment:php-composer

USER www-data:www-data

WORKDIR /var/www/html

RUN composer create-project --prefer-dist laravel/laravel . "5.7.*" \
    && composer require dionera/laravel-beanstalkd-ui \
    && php artisan vendor:publish --all --force

COPY ./beanstalkdui.php /var/www/html/config/beanstalkdui.php

RUN php artisan serve --host="0.0.0.0"

EXPOSE 8000
