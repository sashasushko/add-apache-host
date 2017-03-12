#!/bin/bash

# Порядок действий
# 0. Проверка на отсутствие названия хоста
# 1. Объявление переменных
# 2. Создание папок "www" и "logs" хоста с индексным файлом
# 3. Создание файла конфига по шаблону "apache.sample.conf"
# 4. Добавление хоста
# 5. Перезагрузка Апача
# 6. Уведомление об окончании

# 0.
if [ -z "$1" ]
  then
    echo "Please, set host name as argument and try again."
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
sed "s/%hostname%/$apache_host_name/g" $curent_path/index.sample.html > $HOME/Sites/$apache_host_name/www/index.html

# 3.
sed -e "s/%username%\/Sites\/%hostname%/$user_name\/Sites\/$apache_host_name/g" -e "s/%hostname%/$apache_host_name/g" $curent_path/apache.sample.conf > $curent_path/$apache_host_name.dev.conf
sudo mv $curent_path/$apache_host_name.dev.conf /etc/apache2/vhosts/

# 4.
echo "127.0.0.1 $apache_host_name.dev" | sudo tee -a /etc/hosts

# 5.
sudo apachectl restart

# 6.
echo "Host '$apache_host_name' successfully added."
