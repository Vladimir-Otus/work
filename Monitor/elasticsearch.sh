#!/bin/bash

# Установка зависимостей
sudo apt update
sudo apt install -y default-jdk

# Установка Elasticsearch (предполагаем, что .deb файл уже скачан)
sudo dpkg -i elasticsearch_8.9.1_amd64-224190-f79e75.deb
sudo apt-get install -f -y

# Простая настройка памяти
echo "-Xms1g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options
echo "-Xmx1g" | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options

# Запуск сервиса
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Ждем запуска
sleep 30
echo "Elasticsearch установлен и запущен!"
