#!/usr/bin/env bash

#apt-get update
#apt-get install -y python3-pip
#pip3 install git+git://github.com/Lokaltog/powerline
#wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
#sudo mv PowerlineSymbols.otf /usr/share/fonts/
#wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
#sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

service iptables stop
chkconfig iptables off

yum update -y
#yum install java-1.8.0-openjdk-headless

#if ! [ -L /var/www ]; then
#  rm -rf /var/www
#  ln -fs /vagrant /var/www
#fi
