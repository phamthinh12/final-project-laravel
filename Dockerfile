# Sửa dòng này: Dùng PHP 8.4 để khớp với code ở máy bạn
FROM php:8.4-apache

# 1. Cài đặt các tiện ích hệ thống
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql zip bcmath

# 2. Cấu hình Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# 3. Bật Rewrite mod
RUN a2enmod rewrite

# 4. Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Set working directory
WORKDIR /var/www/html

# 6. Copy code
COPY . .

# 7. Chạy Composer (Thêm cờ --ignore-platform-reqs phòng hờ, nhưng dùng đúng PHP 8.4 thì không cần thiết lắm, cứ để cho chắc)
RUN composer install --no-dev --optimize-autoloader

# 8. Cấp quyền (Quan trọng)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Mở cổng
EXPOSE 80