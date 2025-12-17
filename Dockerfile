FROM php:8.4-apache

# 1. Cài đặt tiện ích
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    ca-certificates \
    && docker-php-ext-install pdo_mysql zip bcmath

# 2. Cấu hình Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# --- ĐOẠN MỚI THÊM: Sửa lỗi 404 Not Found ---
# Cho phép Laravel ghi đè cấu hình để chạy các đường dẫn như /san-pham
RUN echo "<Directory /var/www/html/public>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" > /etc/apache2/conf-available/laravel-override.conf \
&& a2enconf laravel-override
# --------------------------------------------

# 3. Bật Rewrite
RUN a2enmod rewrite

# 4. Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Setup thư mục
WORKDIR /var/www/html

# 6. Copy code
COPY . .

# 7. Cài thư viện
RUN composer install --no-dev --optimize-autoloader

# 8. Cấp quyền
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Mở cổng
EXPOSE 80