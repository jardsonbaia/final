#!/bin/bash

#instalando e atualizando
sudo apt update -y
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc -y
sudo apt -y install php libapache2-mod-php php-mysql
sudo apt install apache2 -y
sudo apt install mysql-server -y
sudo apt install curl -y

#instalando o wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

#CONFIGURA MYSQL PRA RECEBER O WORDPRESS
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';

FLUSH PRIVILEGES;
EOF

#ALGUMAS MODIFICAÇÕES NO APACHE2

sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/apache2/apache2.conf
sudo a2dissite 000-default.conf
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service

cd /var/www/html
#sudo mkdir d
#cd /var/www/html/d
sudo mkdir ind
sudo mv index.html ind
sudo chown -R `whoami`:www-data /var/www/html
wp core download --locale=pt_BR
#CONFIGURANDO BD DO WORDPRESS
wp core config --dbname=cz --dbuser=root --dbpass=root --dbhost=localhost --dbprefix=coz
wp db create
IP="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"
echo $IP
wp core install --url=http://$IP --title=Blog\ Cozinha --admin_user=admin --admin_password=123456 --admin_email=teste@teste.com.br




