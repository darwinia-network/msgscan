#!/bin/sh

echo "source 'https://rubygems.org'" > Gemfile  
echo "gem 'rails', '~> 7.0.0'" >> Gemfile
# generate Gemfile.lock
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:3.1 bundle install