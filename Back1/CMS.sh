# Устанавливаем PHP и необходимые модули
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Скачиваем WordPress и распаковываем
wget https://ru.wordpress.org/wordpress-6.7.1-ru_RU.tar.gz
tar -xzvf wordpress-6.7.1-ru_RU.tar.gz

# Копируем все в папку apache
sudo cp -r wordpress/* /var/www/html/

# Создаем базу для WordPress
sudo mysql -e "CREATE DATABASE vt;"

# Создаем пользователя и даем права
sudo mysql -e "CREATE USER 'vt'@'localhost' IDENTIFIED BY 'vt';"
sudo mysql -e "GRANT ALL PRIVILEGES ON vt.* TO 'vt'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Скачиваем wp-config
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/wp-config.php

# Удаляем старый wp-config.php если существует
if [ -f "/var/www/html/wp-config.php" ]; then
    sudo rm /var/www/html/wp-config.php
fi

# Копируем новый wp-config.php в папку WordPress
sudo cp wp-config.php /var/www/html/

# Удаляем временный файл wp-config.php
rm wp-config.php

# Удаляем файл apache index (чтобы резолвился нормальный WordPress)
if [ -f "/var/www/html/index.html" ]; then
    sudo rm /var/www/html/index.html
fi

# Устанавливаем правильные права
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
