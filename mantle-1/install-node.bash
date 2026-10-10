#!/bin/bash
# shellcheck disable=SC2016

set -e
set -x

sleep 0.5
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install jq tmux ufw build-essential git curl wget -y
curl -OL https://golang.org/dl/go1.17.9.linux-amd64.tar.gz
sudo tar -C /usr/local/ -xvf go1.17.9.linux-amd64.tar.gz
echo "export GOPATH=\"\$HOME/.go\"" >> ~/.bashrc
echo "export GOROOT=\"/usr/local/go\"" >> ~/.bashrc
echo "export PATH=\"\$PATH:\$GOPATH/bin:\$GOROOT/bin\"" >> ~/.bashrc
sleep 1.0
source $HOME/.bashrc
sleep 1.0
git clone -b v0.3.1 https://github.com/AssetMantle/node.git
cd node && git checkout -b v0.3.1
# Tag v0.3.1 is commit 3e8f688539951f9df2d166bcf2f422425f0f2cb3. Stop unless the clone holds exactly that commit.
test "$(git rev-parse HEAD)" = 3e8f688539951f9df2d166bcf2f422425f0f2cb3
git describe --exact-match --tags $(git log -n1 --pretty='%h')
make install
mantleNode version --long
mantleNode unsafe-reset-all

set +x
