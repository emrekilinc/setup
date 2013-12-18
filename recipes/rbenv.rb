# Ruby version to be installed on server
set_default :ruby_version, "2.0.0-p353" 
# Precaution here, rbenv needs to run this script for everything
# to sit at their place. It must be identical with the installed 
# Ubuntu version on the server
set_default :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install curl git-core"
    run "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
    bashrc = <<-BASHRC
if [ -d $HOME/.rbenv ]; then 
  export PATH="$HOME/.rbenv/bin:$PATH" 
  eval "$(rbenv init -)" 
fi
BASHRC
    put bashrc, "/tmp/rbenvrc"
    run "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
    run "mv ~/.bashrc.tmp ~/.bashrc"
    run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
    run %q{eval "$(rbenv init -)"}
    rbenv_cmd "#{rbenv_bootstrap}"
    rbenv_cmd "install #{ruby_version}"
    rbenv_cmd "global #{ruby_version}"
    run "gem install bundler --no-ri --no-rdoc"
    rbenv_cmd "rehash"
  end
  after "deploy:install", "rbenv:install"
end
