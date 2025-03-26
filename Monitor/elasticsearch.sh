#!/bin/bash

# Установка зависимостей
sudo apt update
sudo apt install -y default-jdk

# Установка Elasticsearch из ЛОКАЛЬНОГО файла
sudo dpkg -i /home/vt/elasticsearch_8.9.1_amd64-224190-f79e75.deb || {
    echo "Ошибка установки Elasticsearch! Пробуем доустановить зависимости..."
    sudo apt --fix-broken install -y
}

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
