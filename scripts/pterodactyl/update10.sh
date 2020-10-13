#!/bin/bash

##############################################
# Just a script to update pterodactyl panel #
#           version 1.0 and above           #
##############################################

echo 'Debug: Checking user'
if [ "${USER}" != 'root' ]; then
  echo "Error: Please run as root, you are ${USER}!"
  exit
fi

echo 'Info: Setting values'
VERSION="v${1}"
OLD_DIRECTORY="${PWD}"
PTERODACTYL_DIRECTORY='/var/www/pterodactyl'

echo 'Info: Checking if version provided'
if [ "${VERSION}" = 'v' ]; then
  echo 'Error: Please provide a version to update to!'
  exit
fi

echo 'Info: Verifying installation'
if [ ! -e "${PTERODACTYL_DIRECTORY}" ]; then
  echo "Error: Pterodactyl not found at ${PTERODACTYL_DIRECTORY}!"
  exit
fi

while true; do
  echo "Info: Do you want to update the panel to ${VERSION}?"
  echo 'Warning: DO NOT USE THIS ON CentOS!'
  echo 'Warning: DO NOT USE THIS TO UPGRADE FROM 0.7 TO 1.0!'
  read -p 'Info: [Y(es)/N(o)] ' yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo 'Error: Please answer yes or no!' ;;
  esac
done

echo 'Info: Starting update'
cd "${PTERODACTYL_DIRECTORY}"

echo 'Debug: Turning maintenance mode on'
php artisan down || exit


if [ -e "${PTERODACTYL_DIRECTORY}/panel.tar.gz" ]; then
  echo 'Debug: Old panel.tar.gz found, deleting it'
  rm -rf "${PTERODACTYL_DIRECTORY}/panel.tar.gz" || exit
fi

echo 'Debug: Downloading new files'
curl -L -o 'panel.tar.gz' "https://github.com/pterodactyl/panel/releases/download/${VERSION}/panel.tar.gz" || exit

echo 'Debug: Unpacking new files'
tar -xzvf 'panel.tar.gz' || exit
rm -f 'panel.tar.gz' || exit

echo 'Debug: Applying permissions'
chmod -R 755 storage/* bootstrap/cache || exit

echo 'Debug: Updating dependencies with composer'
composer install --no-dev --optimize-autoloader || exit

echo 'Debug: Clearing caches'
php artisan view:clear || exit
php artisan config:clear || exit

echo 'Debug: Updating database'
php artisan migrate --force
php artisan db:seed --force

echo 'Debug: Setting permission for www-data'
chown -R www-data:www-data *


echo 'Debug: Restarting queue worker'
php artisan queue:restart

echo 'Debug: Turning maintenance mode off'
php artisan up

echo 'Info: Done upgrading to pterodactyl panel 1.0!'
cd "${OLD_DIRECTORY}"
exit
