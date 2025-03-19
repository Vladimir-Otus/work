# Установка Apache2
sudo apt install apache2 -y

# Заменить "Apache2 Default Page" на "Apache2 - Back2" в файле index.html
sudo sed -i 's/Apache2 Default Page/Apache2 - Back2/' /var/www/html/index.html
