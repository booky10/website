#!/bin/bash

echo 'Debug: Checking user'
if [ "${USER}" != 'root' ]; then
  echo "Error: Please run as root, you are ${USER}!"
  exit 255
fi

echo 'Info: Setting values'
VERSION="v${1:-1.0.2}"
OLD_DIRECTORY="${PWD}"
PTERODACTYL_DIRECTORY='/var/www/pterodactyl'

echo 'Info: Verifying installation'
if [ ! -e "${PTERODACTYL_DIRECTORY}" ]; then
  echo "Error: Pterodactyl not found at ${PTERODACTYL_DIRECTORY}!"
  exit 255
fi

while true; do
  echo "Info: Do you want to upgrade to panel ${VERSION}?"
  echo 'Warning: DO NOT USE THIS ON CentOS!'
  echo 'Warning: THERE IS NO OFFICIAL WAY OF GOING BACK!'

  read -pr 'Info: [Y(es)/N(o)] ' yn

  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo 'Error: Please answer yes or no!' ;;
  esac
done

echo 'Info: Starting installation'
cd "${PTERODACTYL_DIRECTORY}" || exit 255

echo 'Debug: Turning maintenance mode on'
php artisan down || exit 255

if [ -e "${PTERODACTYL_DIRECTORY}/panel.tar.gz" ]; then
  echo 'Debug: Old panel.tar.gz found, deleting it'
  rm -rf "${PTERODACTYL_DIRECTORY}/panel.tar.gz" || exit 255
fi

echo 'Debug: Downloading new files'
curl -L -o 'panel.tar.gz' "https://github.com/pterodactyl/panel/releases/download/${VERSION}/panel.tar.gz" || exit 255

echo 'Debug: Deleting old files'
rm -rf "$(find app public resources -depth | head -n -1 | grep -Fv "$(tar -tf panel.tar.gz)")" || exit 255

echo 'Debug: Unpacking new files'
tar -xzvf 'panel.tar.gz' || exit 255
rm -f 'panel.tar.gz' || exit 255

echo 'Debug: Applying permissions'
chmod -R 755 storage/* bootstrap/cache || exit 255

echo 'Debug: Updating dependencies with composer'
composer install --no-dev --optimize-autoloader || exit 255

echo 'Debug: Clearing caches'
php artisan view:clear || exit 255
php artisan config:clear || exit 255

echo 'Debug: Updating database'
php artisan migrate --force
php artisan db:seed --force

echo 'Debug: Setting permission for www-data'
chown -R www-data:www-data -- *

echo 'Debug: Restarting queue worker'
php artisan queue:restart

echo 'Debug: Turning maintenance mode off'
php artisan up

echo "Info: Done upgrading to pterodactyl panel ${VERSION}!"
cd "${OLD_DIRECTORY}" || exit 255
exit
