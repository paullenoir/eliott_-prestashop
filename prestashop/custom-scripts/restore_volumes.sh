#!/bin/bash

# Installation Docker si nécessaire
if ! command -v docker &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y docker.io
fi

# Installation Docker Compose si nécessaire
if ! command -v docker-compose &>/dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Restaurer les volumes à partir des backups
echo "Restauration des volumes à partir des backups..."

VOLUME_BACKUPS=("db_data" "ps_data" "ps_themes" "ps_modules" "ps_img" "ps_download" "ps_config" "ps_override" "ps_var")

for volume in "${VOLUME_BACKUPS[@]}"; do
    if [ -d "backups/$volume" ]; then
        echo "Restauration du volume : $volume"
        docker volume create $volume
        docker run --rm -v $volume:/data -v $(pwd)/backups/$volume:/backup alpine sh -c "cp -a /backup/* /data/"
    else
        echo "Backup manquant pour le volume : $volume"
    fi
done

echo "Restauration terminée. Lancez maintenant 'docker-compose up -d'."
