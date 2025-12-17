# Dùng PHP 8.4 để khớp với code ở máy bạn và thư viện Laravel mới nhất
FROM php:8.4-apache

# 1. Cài đặt các tiện ích hệ thống
# QUAN TRỌNG: Đã thêm 'ca-certificates' để sửa lỗi kết nối SSL với Aiven
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    ca-certificates \
    && docker-php-ext-install pdo_mysql zip bcmath

# 2. Cấu hình Apache trỏ vào thư mục public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# 3. Bật Rewrite mod để Laravel chạy URL đẹp
RUN a2enmod rewrite

# 4. Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Thiết lập thư mục làm việc
WORKDIR /var/www/html

# 6. Copy toàn bộ code vào Docker
COPY . .

# 7. Chạy Composer để cài thư viện
RUN composer install --no-dev --optimize-autoloader

# 8. Cấp quyền ghi cho storage (Để tránh lỗi 500 khi upload ảnh hay ghi log)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Mở cổng 80
EXPOSE 80