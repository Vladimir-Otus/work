#!/bin/bash

# Установка компонентов (предполагаем, что .deb файлы уже скачаны)
sudo dpkg -i /home/vt/filebeat_8.9.1_amd64-224190-bc3f59.deb
sudo dpkg -i /home/vt/kibana_8.9.1_amd64-224190-f7ebba.deb
sudo dpkg -i /home/vt/logstash_8.9.1_amd64-224190-11b1b0.deb
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
