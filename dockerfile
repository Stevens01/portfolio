FROM php:8.2-fpm

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    git \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Copier le code Laravel
COPY . /var/www
WORKDIR /var/www

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Donner les permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
# Exposer le port HTTP
EXPOSE 3000
#  Lancer le serveur Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
