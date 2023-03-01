#!/bin/bash

# Install Certbot
sudo apt update
sudo apt install certbot

# Stop the GitLab service
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop sidekiq

# Obtain a certificate from Let's Encrypt using Certbot
sudo certbot certonly --standalone --preferred-challenges http -d example.com

# Restart the GitLab service
sudo gitlab-ctl start unicorn
sudo gitlab-ctl start sidekiq

# Configure GitLab to use the SSL certificate
sudo nano /etc/gitlab/gitlab.rb

# Add the following lines to the configuration file:
# external_url 'https://example.com'
# nginx['redirect_http_to_https'] = true
# nginx['ssl_certificate'] = "/etc/letsencrypt/live/example.com/fullchain.pem"
# nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/example.com/privkey.pem"

# Reconfigure GitLab to apply the changes
sudo gitlab-ctl reconfigure
