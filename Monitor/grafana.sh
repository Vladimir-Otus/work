# Установка Prometheus
sudo apt update
sudo apt install prometheus -y

# Скачивание конфигурации prometheus.yml
echo "Скачивание конфигурации prometheus.yml..."
sudo wget -O /etc/prometheus/prometheus.yml https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/prometheus.yml

# Проверка, что файл скачан
if [ -f "/etc/prometheus/prometheus.yml" ]; then
    echo "Конфигурация prometheus.yml успешно загружена."
    # Перезапуск Prometheus для применения новой конфигурации
    sudo systemctl restart prometheus
else
    echo "Ошибка: не удалось загрузить конфигурацию prometheus.yml"
    exit 1
fi

sudo systemctl enable prometheus
sudo systemctl start prometheus

# Установка Grafana OSS из папки /home/vt/
sudo apt-get install -y adduser libfontconfig1 musl
sudo dpkg -i /home/vt/grafana_11.4.0_arm64.deb

# Рестарт демона и запуск сервера Grafana
sleep 3
sudo systemctl daemon-reload
sleep 3
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Открытие портов (если используется ufw)
if command -v ufw &> /dev/null; then
    sudo ufw allow 9090/tcp
    sudo ufw allow 9100/tcp
    echo "Порты 9090 и 9100 открыты в ufw."
else
    echo "ufw не установлен. Пропуск открытия портов."
fi

echo "Установка и настройка завершены."
