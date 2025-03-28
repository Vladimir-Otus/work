#!/bin/bash

# Установка hostname
# sudo hostnamectl set-hostname ELK-Grafana
# sudo sed -i "s/^127.0.1.1 .*/127.0.1.1 ELK-Grafana/" /etc/hosts
# echo "Hostname изменен на: $(hostname)"

# Установка JDK
sudo apt update
sudo apt install default-jdk -y

# Установка пакетов ELK
sudo dpkg -i *.deb
sudo apt-get install -f -y

# Настройка лимитов памяти для Elasticsearch
sudo mkdir -p /etc/elasticsearch/jvm.options.d
echo "-Xms1g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options
echo "-Xmx3g" | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options

# Скачивание конфигов (исправленная версия без ассоциативного массива)
config_files=(
    "elasticsearch.yml"
    "filebeat.yml"
    "kibana.yml"
    "logstash.yml"
    "logstash-nginx.conf"
)

config_urls=(
    "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/elasticsearch.yml"
    "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/filebeat.yml"
    "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/kibana.yml"
    "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash.yml"
    "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash-nginx.conf"
)

for i in "${!config_files[@]}"; do
    if [ ! -f "${config_files[$i]}" ]; then
        echo "Скачиваю ${config_files[$i]}..."
        sudo wget -O "${config_files[$i]}" "${config_urls[$i]}"
    fi
done

# Копирование конфигов с проверкой
[ -f elasticsearch.yml ] && sudo cp elasticsearch.yml /etc/elasticsearch/
[ -f filebeat.yml ] && sudo cp filebeat.yml /etc/filebeat/
[ -f kibana.yml ] && sudo cp kibana.yml /etc/kibana/
[ -f logstash.yml ] && sudo cp logstash.yml /etc/logstash/
[ -f logstash-nginx.conf ] && sudo cp logstash-nginx.conf /etc/logstash/conf.d/

# Перезагрузка демона systemd
sudo systemctl daemon-reload

# Запуск Elasticsearch с ожиданием
echo "Запуск Elasticsearch..."
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

echo "Ожидание инициализации Elasticsearch (60 секунд)..."
sleep 60  # Увеличено время ожидания для Elasticsearch 8.x

# Проверка статуса Elasticsearch
if ! systemctl is-active --quiet elasticsearch.service; then
    echo "ОШИБКА: Elasticsearch не запустился"
    echo "Последние логи Elasticsearch:"
    journalctl -u elasticsearch -n 50 --no-pager | grep -i error
    echo "Попытка ручного запуска для диагностики..."
    sudo -u elasticsearch /usr/share/elasticsearch/bin/elasticsearch -d
    sleep 10
    if ! ps aux | grep -v grep | grep elasticsearch; then
        echo "Elasticsearch не смог запуститься. Проверьте:"
        echo "1. Достаточно ли памяти (требуется минимум 4GB)"
        echo "2. Нет ли конфликтов в конфигах"
        echo "3. Логи в /var/log/elasticsearch/"
        exit 1
    fi
fi

# Запуск остальных сервисов
services=("kibana" "logstash" "filebeat")
for service in "${services[@]}"; do
    echo "Запуск $service..."
    sudo systemctl enable $service.service
    sudo systemctl start $service.service
    
    # Проверка статуса каждого сервиса
    sleep 5
    if ! systemctl is-active --quiet $service.service; then
        echo "ВНИМАНИЕ: $service не запустился автоматически"
        journalctl -u $service -n 20 --no-pager | grep -i error
    fi
done

# Финальная проверка статусов
echo "Проверка статусов сервисов:"
printf "%-15s %-10s\n" "Сервис" "Статус"
printf "=====================\n"
for service in "${services[@]}" "elasticsearch"; do
    status=$(systemctl is-active $service.service)
    printf "%-15s %-10s\n" "$service" "$status"
done

# Дополнительная информация для Elasticsearch
if systemctl is-active --quiet elasticsearch.service; then
    echo -e "\nИнформация для доступа к Elasticsearch:"
    echo "Пароль пользователя 'elastic':"
    sudo grep "Password for the elastic user" /var/log/elasticsearch/*.log | tail -1 | awk '{print $NF}'
    echo -e "\nДля генерации токена Kibana выполните:"
    echo "sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana"
fi
