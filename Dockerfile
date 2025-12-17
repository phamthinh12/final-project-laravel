# Sử dụng PHP 8.2 kèm Apache (Web server phổ biến nhất)
FROM php:8.2-apache

# 1. Cài đặt các tiện ích hệ thống cần thiết và thư viện bổ trợ cho PHP
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql zip bcmath

# 2. Cấu hình Apache để trỏ thẳng vào thư mục public của Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# 3. Bật tính năng Rewrite của Apache (để các đường dẫn Laravel hoạt động)
RUN a2enmod rewrite

# 4. Cài đặt Composer (Công cụ quản lý thư viện PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Thiết lập thư mục làm việc
WORKDIR /var/www/html

# 6. Copy toàn bộ code từ máy tính vào trong Docker
COPY . .

# 7. Chạy lệnh cài đặt các thư viện Laravel (vendor)
RUN composer install --no-dev --optimize-autoloader

# 8. Cấp quyền ghi cho thư mục storage và cache (CỰC KỲ QUAN TRỌNG)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Mở cổng 80 (Mặc định của Apache)
EXPOSE 80