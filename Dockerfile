FROM prestashop/prestashop:latest

# Copie des fichiers de configuration personnalisés (thèmes, modules, etc.)
COPY prestashop/backups/themes /var/www/html/themes
COPY prestashop/backups/modules /var/www/html/modules
COPY prestashop/backups/config /var/www/html/config

# Appliquez les permissions nécessaires
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Commande de démarrage
CMD ["apache2-foreground"]
