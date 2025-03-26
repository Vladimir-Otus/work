#!/bin/bash

# Установка компонентов (предполагаем, что .deb файлы уже скачаны)
sudo dpkg -i /home/vt/filebeat_8.9.1_amd64-224190-bc3f59.deb
sudo dpkg -i /home/vt/kibana_8.9.1_amd64-224190-f7ebba.deb
sudo dpkg -i /home/vt/logstash_8.9.1_amd64-224190-11b1b0.deb
sudo apt-get install -f -y
sudo apt-get install -y wget  # Установка wget для скачивания файлов

# Функция для загрузки и замены конфигурационных файлов
replace_config() {
    local url=$1
    local dest=$2
    local backup="${dest}.bak"
    
    # Создаем бекап существующего файла, если он есть
    if [ -f "$dest" ]; then
        sudo cp "$dest" "$backup"
        echo "Создан бекап существующего файла: $backup"
        sudo rm "$dest"
    fi
    
    # Скачиваем новый конфигурационный файл
    sudo mkdir -p "$(dirname "$dest")"
    sudo wget -O "$dest" "$url"
    
    # Проверяем успешность скачивания
    if [ $? -eq 0 ]; then
        echo "Файл успешно загружен и сохранен в: $dest"
    else
        echo "Ошибка при загрузке файла из $url"
        # Восстанавливаем бекап при ошибке
        if [ -f "$backup" ]; then
            sudo mv "$backup" "$dest"
            echo "Восстановлен оригинальный файл из бекапа"
        fi
        exit 1
    fi
}

# Замена конфигурационных файлов
replace_config "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/filebeat.yml" "/etc/filebeat/filebeat.yml"
replace_config "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/kibana.yml" "/etc/kibana/kibana.yml"
replace_config "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash.yml" "/etc/logstash/logstash.yml"
replace_config "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash-nginx.conf" "/etc/logstash/conf.d/logstash-nginx.conf"

# Установка прав на конфигурационные файлы
sudo chown root:root /etc/filebeat/filebeat.yml
sudo chown kibana:kibana /etc/kibana/kibana.yml
sudo chown logstash:logstash /etc/logstash/logstash.yml
sudo chown logstash:logstash /etc/logstash/conf.d/logstash-nginx.conf

# Запуск сервисов
sudo systemctl daemon-reload
sudo systemctl enable kibana logstash filebeat
sudo systemctl restart kibana logstash filebeat  # Используем restart вместо start для применения новых конфигураций

# Проверка статуса
echo "Статус сервисов:"
echo "Elasticsearch: $(systemctl is-active elasticsearch)"
echo "Kibana: $(systemctl is-active kibana)"
echo "Logstash: $(systemctl is-active logstash)"
echo "Filebeat: $(systemctl is-active filebeat)"

echo "Установка завершена!"
