### Prometheus installation
apt install prometheus -y
wget https://raw.githubusercontent.com/Vladimir-Otus/work/refs/heads/main/Monitor/prometheus.yml
cp prometheus.yml /etc/prometheus/prometheus.yml;

### Java installation
apt install default-jdk -y;

### Grafana installation
apt-get install -y adduser libfontconfig1 musl
scp -o ConnectTimeout=10 vt@192.168.8.134:/home/vt/Distr/grafana_11.4.0_amd64.deb /home/vt/
dpkg -i /home/vt/grafana_11.4.0_amd64.deb
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server

### ELK packages copy
scp -o ConnectTimeout=10 vt@192.168.8.134:/home/vt/Distr/filebeat_8.9.1_amd64*.deb /home/vt/
scp -o ConnectTimeout=10 vt@192.168.8.134:/home/vt/Distr/elasticsearch_8.9.1_amd64*.deb /home/vt/
scp -o ConnectTimeout=10 vt@192.168.8.134:/home/vt/Distr/kibana_8.9.1_amd64*.deb /home/vt/
scp -o ConnectTimeout=10 vt@192.168.8.134:/home/vt/Distr/logstash_8.9.1_amd64*.deb /home/vt/

### ELK installation
dpkg -i /home/vt/elasticsearch_8.9.1_amd64*.deb
dpkg -i /home/vt/logstash_8.9.1_amd64*.deb
dpkg -i /home/vt/kibana_8.9.1_amd64*.deb
dpkg -i /home/vt/filebeat_8.9.1_amd64*.deb

### Configure JVM options
# mkdir -p /etc/elasticsearch/jvm.options.d
echo -e "-Xms1g\n-Xmx1g" > /etc/elasticsearch/jvm.options.d/jvm.options

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

### Set proper permissions
#chown elasticsearch:elasticsearch /etc/elasticsearch/elasticsearch.yml
#chown logstash:logstash /etc/logstash/logstash.yml

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
