# установка nginx
sudo apt install -y nginx;

# скачать nginx - site-available
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/sites-available -O /tmp/nginx-sites-available

# Проверить, скачался ли файл
if [ -f /tmp/nginx-sites-available ]; then
    echo "Файл успешно скачан."

    # Копировать файл в /etc/nginx/sites-available/default
    sudo cp -f /tmp/nginx-sites-available /etc/nginx/sites-available/default

    # Проверить, скопировался ли файл
    if [ -f /etc/nginx/sites-available/default ]; then
        echo "Файл успешно скопирован в /etc/nginx/sites-available/default."
    else
        echo "Ошибка: файл не скопирован. Проверьте права доступа или путь."
        exit 1
    fi
else
    echo "Ошибка: файл не скачан. Проверьте URL или подключение к интернету."
    exit 1
fi

# Перезапуск Nginx
sudo systemctl restart nginx;

# Установка Prometheus
sudo apt install prometheus -y;
