# Setup

This script installs a brand new Ubuntu(12.04) machine, to a deploy ready
server for Ruby on Rails application. It handles all the setup which includes,

```
python-software-properties
nginx
nodejs
postgresql
rbenv
unicorn
imagemagick
```

With this setup you will have zero downtime deployment using unicorn with nginx.

To setup the server you need to run these commands in order. First you need to login to the newly setup server via ssh and create a user in ```sudo``` group.

```
adduser {username} --ingroup sudo (for Ubuntu 12.04)
```

After this all you have to do run the commands below in order to setup your server and deploy your application.

```
cap deploy:install
cap deploy:setup
cap deploy:cold
```

After the first deployment, you will run ```cap deploy```.

### Capistrano

This script uses capistrano 2.15.5 for now. In the future i will update this to use, capistrano 3.x.

2013
