#!/bin/bash

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

# Always chown webroot for better mounting
chown -Rf nginx:nginx /usr/share/nginx/html

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf

#Autoloader Optimization
# composer install --optimize-autoloader --no-dev
composer install

php artisan migrate

#Optimizing Configuration Loading
php artisan config:cache

#Optimizing Route Loading
php artisan route:cache

#Optimizing View Loading
php artisan view:cache
