# Emre Kılınç, 09/12/2013
# This is a full server setup script developed with Capistrano
# It handles all the necessary installations for a brand new server
# All you need to do is login to server and create a deployer user
# and change the :user variable in this file. Enjoy!
# adduser {username} --ingroup sudo (for Ubuntu 12.04)
#
# To start setting up the server, here are the commands in order:
# cap deploy:install
# cap deploy:setup
# cap deploy:cold
#
# After the initial deployment all you need to do is to run;
# cap deploy
require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/imagemagick"
load "config/recipes/rbenv"
load "config/recipes/check"

server "your server ip goes here", :web, :app, :db, primary: true

set :application, "application name goes here"
set :user, "deployer username goes here"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :copy
set :use_sudo, false

set :format, :pretty
set :shared_children, shared_children + %w{public/upload}

set :scm, "git"
set :repository, "git@github.com:emrekilinc/#{application}.git"
set :branch, "production"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
