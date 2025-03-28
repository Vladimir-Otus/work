### Nginx installation
apt install nginx -y;
sleep 3;
apt install prometheus -y;

### Site
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/sites-available;
cp sites-available /etc/nginx/sites-available/default;

###  nginx restart
systemctl restart nginx;

sleep 5;

###Filebeat installation
scp -r vt@192.168.8.134:/home/vt/Distr/filebeat_8.9.1_amd64-224190-bc3f59.deb /home/vt/

dpkg -i filebeat_8.9.1_amd64-224190-bc3f59.deb

### filebeat configuration
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/filebeat-Front.yml
cp filebeat-Front.yml /etc/filebeat/filebeat.yml
systemctl restart filebeat
systemctl enable filebeat

