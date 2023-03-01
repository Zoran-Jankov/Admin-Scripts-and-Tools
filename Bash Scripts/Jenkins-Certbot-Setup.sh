#!/bin/bash

# Install Certbot
sudo apt update
sudo apt install certbot

# Stop the Jenkins service
sudo systemctl stop jenkins

# Obtain a certificate from Let's Encrypt using Certbot
sudo certbot certonly --standalone --preferred-challenges http -d example.com

# Restart the Jenkins service
sudo systemctl start jenkins

# Configure Jenkins to use the SSL certificate
sudo nano /etc/default/jenkins

# Add the following line to the configuration file:
# HTTPS_PORT=443
# HTTPS_KEYSTORE=/etc/letsencrypt/live/example.com/keystore
# HTTPS_KEYSTORE_PASSWORD=changeit

# Reconfigure Jenkins to apply the changes
sudo systemctl restart jenkins
