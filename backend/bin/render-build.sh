#!/usr/bin/env bash
# exit on error
set -o errexit

php artisan migrate
php artisan db:seed
