### Prometheus installation
apt install prometheus -y
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/prometheus.yml
cp prometheus.yml /etc/prometheus/prometheus.yml;

#Grafana installation
scp -r vt@192.168.8.133:/home/vt/Distr/*.deb /home/vt/
sleep 3;
sudo apt-get install -y adduser libfontconfig1 musl
sudo dpkg -i grafana_11.4.0_amd64.deb

#Starting Grafana
systemctl daemon-reload;
echo "Starting Grafana"
systemctl start grafana-server

### Java installation
apt install default-jdk -y;

### Debs for ELK installation
dpkg -i *.deb;

### Limits
echo -e "-Xms1g\n-Xmx1g" | sudo cat > /etc/elasticsearch/jvm.options.d/jvm.options;

### Download configs
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/elasticsearch.yml;
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Front/filebeat.yml;
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/kibana.yml;
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash.yml;
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/logstash-nginx-es.conf;



### Copy configs
cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml;
cp filebeat.yml /etc/filebeat/filebeat.yml;
cp kibana.yml /etc/kibana/kibana.yml;
cp logstash.yml /etc/logstash/logstash.yml;
cp logstash-nginx-es.conf /etc/logstash/conf.d/logstash-nginx-es.conf;


### Starting ELK
systemctl daemon-reload;
systemctl enable --now elasticsearch.service;
systemctl daemon-reload;
systemctl enable --now kibana.service;
systemctl enable --now logstash.service;
systemctl restart logstash.service;
systemctl restart filebeat;
systemctl enable filebeat;
systemctl restart kibana;
systemctl restart logstash;
systemctl restart elasticsearch;
systemctl restart prometheus;
