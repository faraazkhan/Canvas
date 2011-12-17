#!/bin/bash -xue

# sync up
yum update

# install support packages
yum groupinstall "Development Tools"
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel libxml2  libxml2-devel libxslt libxslt-devel ruby-devel ruby-rdoc install curl-devel httpd-devel apr-devel apr-util-devel
yum install make bzip2 autoconf automake libtool bison iconv-devel
yum install -y java java-devel
yum groupinstall "MYSQL Database Server" "MYSQL Database Client"
yum install zlib-devel ImageMagick
yum install mysql-devel httpd mod_ssl libssl-devel

#create source directory
mkdir -p ~/sources
cd ~/sources

# nodejs
wget http://nodejs.org/dist/v0.6.6/node-v0.6.6.tar.gz
tar -zxf node-v0.6.6.tar.gz
cd node-v0.6.6
./configure
make 
make install
echo "export PATH=$PATH:/opt/node/bin" > ~/.bash_profile

# install redis
cd ~/sources
wget http://redis.googlecode.com/files/redis-2.2.15.tar.gz
tar xzvf redis-2.2.15.tar.gz
cd redis-2.2.15
make

# back to root
cd ~

# set up system ruby environment
gem update
gem install bundler
gem install passenger
passenger-install-apache2-module
gem update rake
gem install execjs
gem install coffee-script
gem install therubyracer
passenger-install-apache2-module

# install apache
cd ~
yum install httpd mod_ssl

# set up apache config file
cd ./
mv apache_config_file /etc/httpd/conf/httpd.conf


# create application directory
cd ~
mkdir -p /var/www/applications/rationalizeitconsulting.com


# install rvm 
cd /var/www/applications
bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
source .bash_profile



