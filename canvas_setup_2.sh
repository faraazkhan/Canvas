#!/bin/bash -xue

# shutdown terminal

# restart terminal

# set up rvm ruby environment
cd /var/www/applications
rvm install ree
rvm use ree --default
rvm gemset create canvas
rvm use ree@canvas
echo "rvm use ree@canvas" > .rvmrc
-- RVM RubyGems
gem install bundler

# start mysql server
mysqld_safe

# create mysql databases
MYSQL=`which mysql`
 
Q1="CREATE DATABASE IF NOT EXISTS canvas_development;"
Q2="CREATE DATABASE IF NOT EXISTS canvas_queue_development;"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

$MYSQL -uroot -p -e "$SQL"

# Initial Database Set up (Manual steps)
$GEM_HOME/bin/bundle exec rake db:initial_setup
$GEM_HOME/bin/bundle exec rake canvas:compile_assets




# start apache
/etc/init.d/httpd start