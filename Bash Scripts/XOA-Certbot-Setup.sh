#!/bin/bash

# Install certbot
sudo apt update
sudo apt install certbot

# Stop the Apache server if it's running
sudo systemctl stop apache2

# Generate the SSL certificate with certbot
sudo certbot certonly --standalone -d yourdomain.com

# Start the Apache server
sudo systemctl start apache2

# Create a cron job to renew the certificate automatically
(crontab -l ; echo "0 0 * * * certbot renew --quiet") | crontab -

# Verify that the certificate was installed correctly
sudo certbot certificates
