#!/bin/bash -eux
sudo chown -R www-data: /var/www/html 
sudo a2enmod rewrite
sudo chmod -R 755 /var/www/html 
sudo systemctl restart apache2
