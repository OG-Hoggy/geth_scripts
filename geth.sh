#!/bin/bash

cd ~

#You will want to replace this with the most recent version of go at https://go.dev/dl/
sudo wget https://dl.google.com/go/go1.18.linux-amd64.tar.gz  #NEEDS TO BE MOST RECENT VERSION https://golang.org/dl/

tar -C ~ -xvzf go1.18.linux-amd64.tar.gz

export GOROOT=~/go

cd ~/go

export PATH=$GOROOT/bin:$PATH

cd ~

sudo git clone https://github.com/ethereum/go-ethereum.git

sudo apt-get install -y build-essential

sudo echo "export PATH=$PATH:~/go/bin" >> /etc/profile
sudo echo "export GOPATH=~/go/bin" >> /etc/profile

source /etc/profile

cd ~/go-ethereum

sudo make ./geth

#Below will run Ethereum client as a full-archive node and use the logical volume
#located in /mnt to use as the driv to store etherum data in

sudo ./build/bin/geth --mainnet --datadir=/mnt/lv/ethereum --syncmode full \
  --gcmode archive --cache 16384 --http --http.addr 0.0.0.0 --http.api eth,debug \
  --ws --ws.addr 0.0.0.0 --ws.api eth,debug

