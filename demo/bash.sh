#!/bin/bash
# filepath: /var/www/fexend-theme/test/deploy.sh

# Fexend Theme deployment script
# This script automates the deployment process for the Fexend theme

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DEPLOY_DIR="/var/www/fexend-theme"
BACKUP_DIR="/var/www/backups"
LOG_FILE="/var/log/fexend/deploy_$TIMESTAMP.log"
REPO_URL="https://github.com/yourusername/fexend-theme.git"
BRANCH="master"

# Function for logging
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function for error handling
error_exit() {
  log "ERROR: $1"
  exit 1
}

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Start deployment
log "Starting deployment of Fexend Theme"
log "Deployment timestamp: $TIMESTAMP"

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  log "Creating backup directory: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR" || error_exit "Failed to create backup directory"
fi

# Backup existing installation
if [ -d "$DEPLOY_DIR" ]; then
  log "Backing up existing installation"
  tar -czf "$BACKUP_DIR/fexend-theme-backup-$TIMESTAMP.tar.gz" -C "$(dirname "$DEPLOY_DIR")" "$(basename "$DEPLOY_DIR")" || error_exit "Backup failed"
  log "Backup saved to $BACKUP_DIR/fexend-theme-backup-$TIMESTAMP.tar.gz"
fi

# Clone or update repository
if [ -d "$DEPLOY_DIR/.git" ]; then
  log "Updating existing repository"
  cd "$DEPLOY_DIR" || error_exit "Failed to change directory"
  git fetch --all || error_exit "Git fetch failed"
  git checkout "$BRANCH" || error_exit "Git checkout failed"
  git pull origin "$BRANCH" || error_exit "Git pull failed"
else
  log "Cloning repository"
  rm -rf "$DEPLOY_DIR"
  git clone --branch "$BRANCH" "$REPO_URL" "$DEPLOY_DIR" || error_exit "Git clone failed"
  cd "$DEPLOY_DIR" || error_exit "Failed to change directory"
fi

# Install dependencies
if [ -f "$DEPLOY_DIR/package.json" ]; then
  log "Installing npm dependencies"
  npm ci || error_exit "npm install failed"
fi

if [ -f "$DEPLOY_DIR/composer.json" ]; then
  log "Installing composer dependencies"
  composer install --no-dev --optimize-autoloader || error_exit "Composer install failed"
fi

# Build assets
if [ -f "$DEPLOY_DIR/package.json" ]; then
  log "Building assets"
  npm run build || error_exit "Asset build failed"
fi

# Update permissions
log "Updating permissions"
find "$DEPLOY_DIR" -type d -exec chmod 755 {} \;
find "$DEPLOY_DIR" -type f -exec chmod 644 {} \;

# Set specific permissions for storage directories
if [ -d "$DEPLOY_DIR/storage" ]; then
  log "Setting storage permissions"
  chmod -R 775 "$DEPLOY_DIR/storage"
  chmod -R 775 "$DEPLOY_DIR/bootstrap/cache" 2>/dev/null || true
fi

# Clear cache if needed
if [ -f "$DEPLOY_DIR/artisan" ]; then
  log "Clearing Laravel cache"
  php "$DEPLOY_DIR/artisan" cache:clear || error_exit "Failed to clear cache"
  php "$DEPLOY_DIR/artisan" config:clear || error_exit "Failed to clear config"
  php "$DEPLOY_DIR/artisan" route:clear || error_exit "Failed to clear routes"
  php "$DEPLOY_DIR/artisan" view:clear || error_exit "Failed to clear views"
fi

log "Deployment completed successfully!"
exit 0
