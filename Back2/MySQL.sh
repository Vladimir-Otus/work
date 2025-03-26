# Установка MySQL 8.0
sudo apt update
sudo apt install mysql-server -y

# Загрузка и замена конфигурационного файла
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back2/MySQL.cnf -O /etc/mysql/mysql.conf.d/mysqld.cnf

# Перезапуск MySQL
sudo service mysql restart

# Остановка текущей репликации (если она была настроена)
sudo mysql -u root -e "STOP REPLICA;"

# Настройка мастера для репликации
sudo mysql -u root -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.8.131', SOURCE_USER='repl', SOURCE_PASSWORD='oTUSlave#2020', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;"

# Запуск репликации
sudo mysql -u root -e "START REPLICA;"

# Проверка статуса репликации
sudo mysql -u root -e "SHOW REPLICA STATUS\G;"
