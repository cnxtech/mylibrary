# frozen_string_literal: true

set :application, 'mylibrary'
set :repo_url, 'git@github.com:sul-dlss/mylibrary.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/app/mylibrary/mylibrary'

set :linked_files, fetch(:linked_files, []).push(
  'config/honeybadger.yml',
  'config/newrelic.yml'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'config/settings'
)

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :honeybadger_env, fetch(:stage)

# update shared_configs before restarting app
before 'deploy:restart', 'shared_configs:update'
