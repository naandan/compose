FROM php:8.1-apache

RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www/html

COPY . .

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install

RUN chown -R www-data:www-data /var/www/html/storage
RUN chmod -R 775 /var/www/html/storage
RUN chmod -R 775 /var/www/html/public

RUN a2enmod rewrite

EXPOSE 80

RUN echo "#!/bin/bash" > /usr/local/bin/start.sh
RUN echo "php artisan migrate" >> /usr/local/bin/start.sh
RUN echo "php artisan serve --host=0.0.0.0 --port=8000" >> /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
