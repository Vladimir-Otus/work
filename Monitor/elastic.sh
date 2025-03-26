#!/bin/bash

# Установка зависимостей
sudo apt update
sudo apt install -y default-jdk wget

# Установка Elasticsearch (предполагаем, что .deb файл уже скачан)
sudo dpkg -i /home/vt/elasticsearch_8.9.1_amd64-224190-f79e75.deb

# Скачивание и замена конфигурационного файла
ELASTIC_YML="/etc/elasticsearch/elasticsearch.yml"
BACKUP_YML="/etc/elasticsearch/elasticsearch.yml.bak"

# Создаем бекап существующего файла, если он есть
if [ -f "$ELASTIC_YML" ]; then
    sudo cp "$ELASTIC_YML" "$BACKUP_YML"
    echo "Существующий конфигурационный файл сохранен как $BACKUP_YML"
    sudo rm "$ELASTIC_YML"
fi

# Скачиваем новый конфигурационный файл
sudo wget -O "$ELASTIC_YML" https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/elasticsearch.yml

# Проверяем успешность скачивания
if [ $? -eq 0 ]; then
    echo "Конфигурационный файл успешно загружен и сохранен в $ELASTIC_YML"
else
    echo "Ошибка при загрузке конфигурационного файла"
    exit 1
fi

# Простая настройка памяти
sudo mkdir -p /etc/elasticsearch/jvm.options.d
echo "-Xms1g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options
echo "-Xmx1g" | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options

# Запуск сервиса
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Ждем запуска
sleep 30
echo "Elasticsearch установлен и запущен!"
