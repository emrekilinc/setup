# This file will automatically generate the 
# database.yml file and will send it to the applications'
# config directory. I am taking the password via capistrano prompt
set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application } # This means we're gonna have the same username with the application
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "Please specify the PostgreSQL Password: " }
set_default(:postgresql_database) { "#{application}_v1" } # This may change for every application

namespace :postgresql do
  desc "Install the latest release of PostgreSQL"
  task :install, roles: :db, only: {primary: true} do
    add_apt_repository("ppa:pitti/postgresql")
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install postgresql libpq-dev"
  end
  after "deploy:install", "postgresql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Generate the database.yml configuration file"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"
end
