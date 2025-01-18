# FROM prestashop/prestashop:latest

# # Copie des fichiers de configuration personnalisés (thèmes, modules, etc.) si les fichiers existent
# RUN [ -d "prestashop/backups/themes" ] && cp -r prestashop/backups/themes /var/www/html/themes || echo "No themes directory to copy"
# RUN [ -d "prestashop/backups/modules" ] && cp -r prestashop/backups/modules /var/www/html/modules || echo "No modules directory to copy"
# RUN [ -d "prestashop/backups/config" ] && cp -r prestashop/backups/config /var/www/html/config || echo "No config directory to copy"

# # Appliquez les permissions nécessaires
# RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# # Commande de démarrage
# CMD ["apache2-foreground"]

FROM prestashop/prestashop:latest

# Installation des extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-install -j$(nproc) \
    intl \
    opcache \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# # Configuration PHP pour Prestashop
# RUN echo "memory_limit=256M" > /usr/local/etc/php/conf.d/memory-limit.ini \
#     && echo "upload_max_filesize=128M" > /usr/local/etc/php/conf.d/upload-max.ini \
#     && echo "post_max_size=128M" >> /usr/local/etc/php/conf.d/upload-max.ini

# # Copie des fichiers de configuration personnalisés
# RUN [ -d "prestashop/backups/themes" ] && cp -r prestashop/backups/themes /var/www/html/themes || echo "No themes directory to copy"
# RUN [ -d "prestashop/backups/modules" ] && cp -r prestashop/backups/modules /var/www/html/modules || echo "No modules directory to copy"
# RUN [ -d "prestashop/backups/config" ] && cp -r prestashop/backups/config /var/www/html/config || echo "No config directory to copy"

# # Configuration Apache
# RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Nettoyage
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["apache2-foreground"]