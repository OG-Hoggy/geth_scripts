#!/bin/bash

cd /mnt/lv

# Copy link from https://prometheus.io/download/
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

#Version may vary
sudo tar xf node_exporter-1.3.1.linux-amd64.tar.gz

#Change to shorter name
sudo mv node_exporter-1.3.1.linux-amd64 node_exporter

#Cleanup unneeded .tar file
sudo rm node_exporter-1.3.1.linux-amd64.tar.gz

cd node_exporter/ 

sudo ./node_exporter  #The is will run the node_exporter agent

#These commands and the two following are used to background the process. 
#They can also be used for the prometheus and grafana services.
ctrl + z  
bg
disown -h

#The service should now be reachable through the public IP associated with the server. The default port number to append to this address is ip_addr:9100

#Copy link from https://prometheus.io/download/
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.34.0/prometheus-2.34.0.linux-amd64.tar.gz

#Version may vary
sudo tar xf prometheus-2.34.0.linux-amd64.tar.gz

#Change to shorter name
sudo mv prometheus-2.34.0.linux-amd64 prometheus

#Cleanup unneeded .tar file
sudo rm prometheus-2.34.0.linux-amd64.tar.gz

cd prometheus/

#Change the listed values of the '-targets' key under the 'static_configs:' to look like this
(sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "prometheus.yml" | sed '$d' && echo "- targets: ['0.0.0.0:9090', '0.0.0.0:9100']") > "prometheus.yml"


#the only thing to be changed in the above command is the $privateIP -> i.e. #.#.#.#:9090 the quotations, brackets, etc. should all remain

sudo ./prometheus --storage.tsdb.retention.time=1y   #run prometheus

#The service should now be reachable through the public IP and private associated with the server. The default port number to append to this address is ip_addr:9090.

