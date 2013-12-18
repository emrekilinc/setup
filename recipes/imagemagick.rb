namespace :imagemagick do
  desc "Installing the latest stable version of ImageMagick"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install imagemagick"
    run "#{sudo} apt-get -y install libmagickwand-dev"
  end
  after "deploy:install", "imagemagick:install"
end
