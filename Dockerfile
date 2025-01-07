# Build stage
FROM composer:2 as composer

WORKDIR /app
COPY composer.* ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

COPY . .
RUN composer dump-autoload --optimize

# Production stage
FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    postgresql-dev \
    libzip-dev \
    && docker-php-ext-install \
    pdo_pgsql \
    zip \
    opcache

# Configure PHP
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/www.conf /usr/local/etc/php-fpm.d/www.conf

# Configure Nginx
COPY docker/nginx.conf /etc/nginx/http.d/default.conf

# Setup application
WORKDIR /var/www/html
COPY --from=composer /app .
RUN chown -R www-data:www-data \
    storage \
    bootstrap/cache

# Configure supervisor
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Security hardening
RUN addgroup -g 1000 laravel && \
    adduser -u 1000 -G laravel -h /var/www/html -s /bin/sh -D laravel

USER laravel

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]