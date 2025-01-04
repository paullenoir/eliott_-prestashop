FROM prestashop/prestashop:latest

# Copie des fichiers de configuration personnalisés (thèmes, modules, etc.)
COPY backups/themes /var/www/html/themes
COPY backups/modules /var/www/html/modules
COPY backups/config /var/www/html/config

# Appliquez les permissions nécessaires
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Commande de démarrage
CMD ["apache2-foreground"]
