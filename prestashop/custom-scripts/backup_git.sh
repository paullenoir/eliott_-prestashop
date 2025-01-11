#!/bin/bash

# Dossier de destination des backups
BACKUP_DIR="backups"
mkdir -p $BACKUP_DIR

VOLUMES=("db_data" "ps_data" "ps_themes" "ps_modules" "ps_img" "ps_download" "ps_config" "ps_override" "ps_var")

# Fonction pour gérer les erreurs
handle_error() {
    echo "Erreur: $1"
    exit 1
}

# Création du dossier de backup
mkdir -p "$BACKUP_DIR" || handle_error "Impossible de créer le dossier de backup"

echo "Début de la sauvegarde des volumes Docker..."

# Créer une archive temporaire pour chaque volume
for volume in "${VOLUMES[@]}"; do
    echo "Sauvegarde du volume : $volume"
    
    # Créer un dossier temporaire pour le volume
    TMP_DIR="/tmp/backup_${volume}"
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    # Copier les données du volume dans une archive tar compressée
    docker run --rm \
        -v "${volume}:/source" \
        -v "${TMP_DIR}:/backup" \
        ubuntu:latest bash -c "cd /source && tar czf /backup/${volume}_${DATE}.tar.gz ."
    
    # Déplacer l'archive dans le dossier de backup
    mv "${TMP_DIR}/${volume}_${DATE}.tar.gz" "$BACKUP_DIR/" || handle_error "Impossible de déplacer l'archive ${volume}"
    
    # Nettoyer le dossier temporaire
    rm -rf "$TMP_DIR"
done

echo "Sauvegarde des volumes terminée."

# Nettoyer les anciens backups (garder seulement les 5 derniers)
for volume in "${VOLUMES[@]}"; do
    cd "$BACKUP_DIR" || handle_error "Impossible d'accéder au dossier backup"
    ls -t "${volume}"_*.tar.gz | tail -n +6 | xargs -r rm
    cd - > /dev/null
done

# Sauvegarde dans GitHub
echo "Ajout des backups au dépôt Git..."

# a faire dans la VM
# git config --global user.name "Votre Nom"
# git config --global user.email "votre.email@exemple.com"

# Vérifier si Git est configuré
if ! git config user.email > /dev/null || ! git config user.name > /dev/null; then
    handle_error "Git n'est pas configuré. Veuillez configurer user.email et user.name"
fi

# Vérifier si on est dans un repo Git
if [ ! -d .git ]; then
    handle_error "Ce n'est pas un dépôt Git. Veuillez initialiser le dépôt d'abord"
fi

# Ajouter et commit les nouveaux backups
git add "$BACKUP_DIR/"*"_${DATE}.tar.gz" || handle_error "Impossible d'ajouter les fichiers à Git"
git commit -m "Backup des volumes Docker du ${DATE}" || handle_error "Impossible de créer le commit"

# Push vers GitHub avec gestion d'erreur
if ! git push origin main; then
    handle_error "Impossible de pusher vers GitHub. Vérifiez votre connexion et vos permissions"
fi

echo "Sauvegarde dans GitHub terminée avec succès."

# Afficher la taille totale des backups
TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
echo "Taille totale des backups : $TOTAL_SIZE"