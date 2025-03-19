###устанавливаем php для CMS
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y;

### скачать wordpress, распаковать
sudo wget https://ru.wordpress.org/wordpress-6.7.1-ru_RU.tar.gz;
sudo tar -xzvf wordpress-6.7.1-ru_RU.tar.gz;

### копируем все в папку apache
sudo cp -r wordpress/* /var/www/html/;

### создаем базу для wp
mysql -u root -e "CREATE DATABASE WP;";

### раздаем права создаем пользователя
mysql -u root -e "CREATE USER 'wp'@'%' IDENTIFIED BY 'password';";
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'wp'@'%';";

### качаем wp-config
sudo https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/WordPress.php

### копируем его в папку wordpress
sudo cp wp-config.php /var/www/html/;

### удаляем файл apache index (чтобы резолвился нормальный wordpress)
sudo rm /var/www/html/index.html;
