#!/usr/bin/env bash
# exit on error
set -o errexit

# throw errors if Gemfile has been modified since Gemfile.lock
bundle config --global frozen 1

bundle exec rails db:prepare
bundle exec rake assets:clean
bundle exec rake assets:precompile

bundle exec puma -C config/puma.rb