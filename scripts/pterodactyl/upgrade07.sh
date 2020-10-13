#!/bin/bash

##############################################
# Just a script to upgrade pterodactyl panel #
#         version 0.7 to version 1.0         #
##############################################

echo 'Debug: Checking user'
if [ "${USER}" != 'root' ]; then
  echo "Error: Please run as root, you are ${USER}!"
  exit
fi

echo 'Info: Setting values'
VERSION="v${1:-1.0.0}"
OLD_DIRECTORY="${PWD}"
PTERODACTYL_DIRECTORY='/var/www/pterodactyl'

echo 'Info: Verifying installation'
if [ ! -e "${PTERODACTYL_DIRECTORY}" ]; then
  echo "Error: Pterodactyl not found at ${PTERODACTYL_DIRECTORY}!"
  exit
fi

while true; do
  echo 'Info: Do you want to upgrade to panel 1.0?'
  echo 'Warning: DO NOT USE THIS ON CentOS!'
  echo 'Warning: THERE IS NO OFFICIAL WAY OF GOING BACK!'
  read -p 'Info: [Y(es)/N(o)] ' yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo 'Error: Please answer yes or no!' ;;
  esac
done

echo 'Info: Starting installation'
cd "${PTERODACTYL_DIRECTORY}"

echo 'Debug: Turning maintenance mode on'
php artisan down || exit


if [ -e "${PTERODACTYL_DIRECTORY}/panel.tar.gz" ]; then
  echo 'Debug: Old panel.tar.gz found, deleting it'
  rm -rf "${PTERODACTYL_DIRECTORY}/panel.tar.gz" || exit
fi

echo 'Debug: Downloading new files'
curl -L -o 'panel.tar.gz' "https://github.com/pterodactyl/panel/releases/download/${VERSION}/panel.tar.gz" || exit

echo 'Debug: Deleting old files'
rm -rf $(find app public resources -depth | head -n -1 | grep -Fv "$(tar -tf panel.tar.gz)") || exit

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
