# Use a base image with PHP and Apache
FROM php:7.4-apache

# Copy application files
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install necessary PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
