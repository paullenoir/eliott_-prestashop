FROM prestashop/prestashop:latest

# Copie des fichiers de configuration personnalisés (thèmes, modules, etc.) si les fichiers existent
RUN [ -d "prestashop/backups/themes" ] && cp -r prestashop/backups/themes /var/www/html/themes || echo "No themes directory to copy"
RUN [ -d "prestashop/backups/modules" ] && cp -r prestashop/backups/modules /var/www/html/modules || echo "No modules directory to copy"
RUN [ -d "prestashop/backups/config" ] && cp -r prestashop/backups/config /var/www/html/config || echo "No config directory to copy"

# Appliquez les permissions nécessaires
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Commande de démarrage
CMD ["apache2-foreground"]