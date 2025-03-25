# Установка Prometheus
sudo apt update
sudo apt install prometheus -y
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Установка Grafana OSS из папки /home/vt/
sudo apt-get install -y adduser libfontconfig1 musl
sudo dpkg -i /home/vt/grafana_11.5.2_amd64.deb

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
