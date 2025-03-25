# закинул deb пакеты в home
# меняем hostname для конфига elasticsearch надо
sudo hostnamectl set-hostname ELK-Grafana
sudo sed -i "s/^127.0.1.1 .*/127.0.1.1 ELK-Grafana/" /etc/hosts
echo "Hostname изменен на: $(hostname)"

# для работы нужен jdk
sudo apt install default-jdk -y

# устанавливаем пакеты пачкой из папки ELK
#cd ELK
sudo dpkg -i *.deb
sudo apt-get install -f -y  # Установка недостающих зависимостей

# устанавливаем лимиты для оперативки
sudo mkdir -p /etc/elasticsearch/jvm.options.d
echo -e "-Xms1g\n-Xmx1g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options > /dev/null

# скачиваем конфиги, если их нет
if [ ! -f elasticsearch.yml ]; then
    sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/elasticsearch.yml
fi
if [ ! -f filebeat.yml ]; then
    sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/filebeat.yml
fi
if [ ! -f kibana.yml ]; then
    sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/kibana.yml
fi
if [ ! -f logstash.yml ]; then
    sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash.yml
fi
if [ ! -f logstash-nginx.conf ]; then
    sudo wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash-nginx.conf
fi

# копируем в нужные папки, если файлы существуют
if [ -f elasticsearch.yml ]; then
    sudo cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
fi
if [ -f filebeat.yml ]; then
    sudo cp filebeat.yml /etc/filebeat/filebeat.yml
fi
if [ -f kibana.yml ]; then
    sudo cp kibana.yml /etc/kibana/kibana.yml
fi
if [ -f logstash.yml ]; then
    sudo cp logstash.yml /etc/logstash/logstash.yml
fi
if [ -f logstash-nginx.conf ]; then
    sudo cp logstash-nginx.conf /etc/logstash/conf.d/logstash-nginx.conf
fi

# рестартуем все возможное
sudo systemctl daemon-reload
sudo systemctl enable --now elasticsearch.service
sudo systemctl enable --now kibana.service
sudo systemctl enable --now logstash.service
sudo systemctl enable --now filebeat.service

sudo systemctl restart elasticsearch
sudo systemctl restart kibana
sudo systemctl restart logstash
sudo systemctl restart filebeat
