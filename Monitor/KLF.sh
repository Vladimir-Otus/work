#!/bin/bash

# Установка компонентов (предполагаем, что .deb файлы уже скачаны)
sudo dpkg -i kibana.deb logstash.deb filebeat.deb
sudo apt-get install -f -y

# Запуск сервисов
sudo systemctl daemon-reload
sudo systemctl enable kibana logstash filebeat
sudo systemctl start kibana logstash filebeat

# Проверка статуса
echo "Статус сервисов:"
echo "Elasticsearch: $(systemctl is-active elasticsearch)"
echo "Kibana: $(systemctl is-active kibana)"
echo "Logstash: $(systemctl is-active logstash)"
echo "Filebeat: $(systemctl is-active filebeat)"

echo "Установка завершена!"
