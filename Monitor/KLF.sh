#!/bin/bash

# Установка зависимостей
sudo apt update
sudo apt install -y wget

# Установка компонентов (предполагаем, что .deb файлы уже скачаны)
sudo dpkg -i kibana.deb logstash.deb filebeat.deb
sudo apt-get install -f -y

# Функция для замены конфигурационных файлов
replace_config() {
    local url=$1
    local dest=$2
    local backup="${dest}.bak"
    
    # Создаем бекап существующего файла, если он есть
    if [ -f "$dest" ]; then
        sudo cp "$dest" "$backup"
        echo "Существующий конфигурационный файл сохранен как $backup"
        sudo rm "$dest"
    fi
    
    # Создаем директорию, если её нет
    sudo mkdir -p $(dirname "$dest")
    
    # Скачиваем новый конфигурационный файл
    sudo wget -O "$dest" "$url"
    
    # Проверяем успешность скачивания
    if [ $? -eq 0 ]; then
        echo "Конфигурационный файл успешно загружен и сохранен в $dest"
    else
        echo "Ошибка при загрузке конфигурационного файла из $url"
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
replace_config "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash-nginx-ex.conf" "/etc/logstash/conf.d/logstash-nginx-ex.conf"  # Измененное имя файла

# Установка правильных прав на файлы
sudo chown kibana:kibana /etc/kibana/kibana.yml
sudo chown logstash:logstash /etc/logstash/logstash.yml
sudo chown logstash:logstash /etc/logstash/conf.d/logstash-nginx-ex.conf  # Обновленное имя файла
sudo chown root:root /etc/filebeat/filebeat.yml

# Запуск сервисов
sudo systemctl daemon-reload
sudo systemctl enable kibana logstash filebeat
sudo systemctl restart kibana logstash filebeat

# Проверка статуса
echo "Статус сервисов:"
echo "Elasticsearch: $(systemctl is-active elasticsearch)"
echo "Kibana: $(systemctl is-active kibana)"
echo "Logstash: $(systemctl is-active logstash)"
echo "Filebeat: $(systemctl is-active filebeat)"

echo "Установка завершена!"
