Тема: «Настройка веб-сервера с балансировкой, репликацией БД и системой мониторинга на базе ELK и Grafana»
Я использую 4 виртуальных машины с Ubuntu 24.10 (Oracle VirtualBox)
1-	Front – 192.168.8.130 
2-	Back1 – 192.168.8.131
3-	Back2 – 192.168.8.132
4-	Monitor – 192.168.8.133

________________________________________________________________
Настройка Front
1-	Скачиваем заранее подготовленный скрипт с GitHub и запускаем:
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/front-script.sh
sudo chmod +x front-script.sh
sudo ./front-script.sh
Проверяем работу дефолтной страницы - http://192.168.8.130
В скрипте также устанавливается Prometheus

2-	Устанавливаем FileBeat, который заранее был скопирован с помощью WinSCP в текущую папку:
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/filebeat-ins.sh
sudo chmod +x filebeat-ins.sh
sudo ./filebeat-ins.sh
_________________________________________________________________
Настройка Back1
1-	Скачиваем заранее подготовленный скрипт с GitHub и запускаем:
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/Apache.sh
sudo chmod +x Apache.sh
sudo ./Apache.sh
Проверяем работу дефолтной страницы - http://192.168.8.131
2-	Настройка MySQL Master:
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/MySQL.sh
sudo chmod +x MySQL.sh
sudo ./MySQL.sh
3-	Настройка CMS (WordPress):
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/CMS.sh
sudo chmod +x CMS.sh
sudo ./CMS.sh
4-	Настраиваем WordPress, но не устанавливаем:
http://192.168.8.131/wp-admin/install.php
___________________________________________________________________
Настройка Back2
1-	Скачиваем заранее подготовленный скрипт с GitHub и запускаем:
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back2/Apache.sh
sudo chmod +x Apache.sh
sudo ./Apache.sh
Проверяем работу дефолтной страницы - http://192.168.8.132
2-	Настройка MySQL Master:
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back2/MySQL.sh
sudo chmod +x MySQL.sh
sudo ./MySQL.sh
3-	Создание баз
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/BD.sh
sudo chmod +x BD.sh
sudo bash BD.sh
password - oTUSlave#2020
4-	Реплика
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back2/replica.sh
sudo chmod +x replica.sh
sudo ./replica.sh
5-	Проверка таблиц
sudo mysql -u root -e "show databases;"

6-	Проверить работу BackUP
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back2/BackUP.sh
sudo chmod +x BackUP.sh
sudo ./BackUP.sh
7-	Настройка CMS (WordPress):
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Back1/CMS.sh
sudo chmod +x CMS.sh
sudo ./CMS.sh
_______________________________________________________________________
Настройка Monitor
1-	Необходимые пакеты ELK+Grafana копируем с помощью WniSCP
2-	Настройка Grafana
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/grafana.sh
sudo chmod +x grafana.sh
sudo ./grafana.sh
3-	Установка elasticsearch
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/elastic.sh
sudo chmod +x elastic.sh
sudo bash elastic.sh
4-	Установка kibana,Logstash, filebeat
sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/KLF.sh
sudo chmod +x KLF.sh
sudo bash KLF.sh
_________________________________________________________________________
