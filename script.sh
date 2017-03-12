#!/bin/bash

# Steps
# 0. Checks
# 1. Var
# 2. Create "www" and "logs" folder
# 3. Place index to host "www" folder
# 4. Create Apache host config file by template "apache.sample.conf" and place it to Apache folder
# 5. Add host
# 6. Restart Apache
# 7. End

# 0.
# Check that user entered a host name
if [ -z "$1" ]
  then
    echo "Please, set host name as first argument and try again."
    exit
fi

# Check that host name contains only latin letters, numbers, dash and underscore
if [[ $1 =~ ^[A-Za-z0-9_-]+$ ]]
  then
    # ToDo: Rewrite "if" construction so that remove "else" block
  else
    echo "Host name must contain only latin letters, numbers, dash and underscore."
	exit
fi

# 1.
apache_host_name=$1
user_name=$USER
if [ -L $0 ]
  then
    curent_path=$(dirname $(readlink -f $0))
  else
    curent_path=$(dirname $0)
fi

# 2.
mkdir $HOME/Sites/$apache_host_name
mkdir $HOME/Sites/$apache_host_name/www
mkdir $HOME/Sites/$apache_host_name/logs

# 3.
sed "s/%hostname%/$apache_host_name/g" $curent_path/index.sample.html > $HOME/Sites/$apache_host_name/www/index.html

# 4.
sed -e "s/%username%/$user_name/g" -e "s/%hostname%/$apache_host_name/g" $curent_path/apache.sample.conf > $curent_path/$apache_host_name.dev.conf
sudo mv $curent_path/$apache_host_name.dev.conf /etc/apache2/vhosts/

# 5.
# ToDo: Replace echo by something invisible to user
echo "127.0.0.1 $apache_host_name.dev" | sudo tee -a /etc/hosts

# 6.
sudo apachectl restart

# 7.
echo "Host '$apache_host_name.dev' successfully added."
