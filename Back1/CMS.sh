# Устанавливаем PHP и необходимые модули
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y;

# Скачиваем WordPress и распаковываем
sudo wget https://ru.wordpress.org/wordpress-6.7.1-ru_RU.tar.gz;
sudo tar -xzvf wordpress-6.7.1-ru_RU.tar.gz;

# Копируем все в папку apache
sudo cp -r wordpress/* /var/www/html/;

# Создаем базу для WordPress
mysql -u root -e "CREATE DATABASE vt;";

# Создаем пользователя и даем права
mysql -u root -e "CREATE USER 'vt'@'%' IDENTIFIED BY 'vt';";
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'vt'@'%';";

# Скачиваем wp-config
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/wp-config.php

# Удаляем старый wp-config.php если существует
if [ -f "/var/www/html/wp-config.php" ]; then
    sudo rm /var/www/html/wp-config.php;
fi

# Копируем новый wp-config.php в папку WordPress
sudo cp wp-config.php /var/www/html/;

# Удаляем временный файл wp-config.php
sudo rm wp-config.php;

# Удаляем файл apache index (чтобы резолвился нормальный WordPress)
if [ -f "/var/www/html/index.html" ]; then
    sudo rm /var/www/html/index.html;
fi
