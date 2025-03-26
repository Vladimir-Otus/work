# Установка hostname
sudo hostnamectl set-hostname ELK-Grafana
sudo sed -i "s/^127.0.1.1 .*/127.0.1.1 ELK-Grafana/" /etc/hosts
echo "Hostname изменен на: $(hostname)"

# Установка JDK
sudo apt update
sudo apt install default-jdk -y

# Установка пакетов ELK
sudo dpkg -i *.deb
sudo apt-get install -f -y

# Настройка лимитов памяти для Elasticsearch
sudo mkdir -p /etc/elasticsearch/jvm.options.d
echo -e "-Xms1g\n-Xmx3g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options >/dev/null

# Скачивание конфигов
declare -A config_urls=(
    ["elasticsearch.yml"]="Monitor/elasticsearch.yml"
    ["filebeat.yml"]="Front/filebeat.yml"
    ["kibana.yml"]="Monitor/kibana.yml"
    ["logstash.yml"]="Monitor/logstash.yml"
    ["logstash-nginx.conf"]="Monitor/logstash-nginx.conf"
)

for config in "${!config_urls[@]}"; do
    if [ ! -f "$config" ]; then
        sudo wget "https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/${config_urls[$config]}"
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

echo "Ожидание инициализации Elasticsearch (30 секунд)..."
sleep 30

# Проверка статуса Elasticsearch
if ! systemctl is-active --quiet elasticsearch.service; then
    echo "ОШИБКА: Elasticsearch не запустился"
    echo "Последние логи Elasticsearch:"
    journalctl -u elasticsearch -n 20 --no-pager
    exit 1
fi

# Запуск остальных сервисов
for service in kibana logstash filebeat; do
    echo "Запуск $service..."
    sudo systemctl enable $service.service
    sudo systemctl start $service.service
    sleep 5
done

echo "Проверка статусов сервисов:"
for service in elasticsearch kibana logstash filebeat; do
    status=$(systemctl is-active $service.service)
    echo "  $service: $status"
done
