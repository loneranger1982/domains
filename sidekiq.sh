#!/bin/bash

clear

echo "Starting Sidekiq Workers"


cd /var/www/domains/code
RAILS_ENV=production
bundle exec sidekiq -c 5  -p sidekiq-{$1}.pid -d -L /home/domains/log/SidekiqWorker{$1}.log


