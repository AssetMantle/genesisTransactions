#!/bin/bash
# shellcheck disable=SC2016

set -e
set -x

sleep 0.5
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install jq tmux ufw build-essential -y
curl -OL https://golang.org/dl/go1.17.9.linux-amd64.tar.gz
sudo tar -C /usr/local/ -xvf go1.17.9.linux-amd64.tar.gz
echo "export GOPATH=\"\$HOME/.go\"" >> ~/.bashrc
echo "export GOROOT=\"/usr/local/go\"" >> ~/.bashrc
echo "export PATH=\"\$PATH:\$GOPATH/bin:\$GOROOT/bin\"" >> ~/.bashrc
sleep 1.0
$(which bash) -c 'source $HOME/.bashrc'
sleep 1.0
git clone -b v0.3.0-RC https://github.com/AssetMantle/node.git
cd node && make install
mantleNode version --long
mantleNode unsafe-reset-all

set +x
