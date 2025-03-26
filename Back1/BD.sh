#!/bin/bash
# Простой скрипт для создания баз данных MySQL

# Запрос пароля MySQL
read -s -p "Введите пароль MySQL для root: " MYSQL_PASS
echo ""

# Список баз данных для создания
DATABASES=("shop" "blog" "forum")

# Создаем каждую базу
for DB in "${DATABASES[@]}"
do
  echo "Создаю базу данных: $DB"
  mysql -u root -p"$MYSQL_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB;"
  
  # Простая таблица для каждой базы
  mysql -u root -p"$MYSQL_PASS" $DB -e "CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
  );"
  
  # Тестовые данные
  mysql -u root -p"$MYSQL_PASS" $DB -e "INSERT INTO users (name, email) VALUES 
    ('Иван Иванов', 'ivan@example.com'),
    ('Петр Петров', 'petr@example.com');"
done

echo "Готово! Созданы базы данных: ${DATABASES[@]}"
mysql -u root -p"$MYSQL_PASS" -e "SHOW DATABASES;"
