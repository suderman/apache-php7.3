#!/bin/sh

# Create mount point for bindfs
# mkdir -p /app/html
# bindfs -o nonempty --mirror=www-data /app /var/www

# rm -rf /var/www
# cp -R /app /var/www
# touch /var/www/copied.txt

# Run Apache in foregrond
apachectl -D FOREGROUND
