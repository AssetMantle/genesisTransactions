# mantle-1
The first main-net of AssetMantle's mantle-1 chain with basic token functionality release.

> Final Genesis and Peer files published

## Description
This document describes how to setup a mantle-1 chain node. 

## Hardware Requirements
| Minimum Requirement | Recommended Requirement |
| ------------------- | ----------------------- |
| v2 CPUs             | v4 CPUs                 |
| 4GB RAM             | 8GB RAM                 |
| 200GB SSD           | 500GB SSD               |

> NOTE: low endurance(tbw) ssd are not recommended for long term node operation

## Operating System
* Linux/Windows/MacOS(x86)
* **Recommended**
  * Linux(x86_64)
  
## Installation Steps

### Update & Upgrade system packages
  ```shell
  sudo apt-get update && sudo apt-get upgrade -y
  ```

### Install essential packages
  ```shell
  sudo apt-get install build-essential git -y
  ```

### Install Go
* Download Go version 1.17.9 , ref - [go's official website](https://go.dev/dl/).
  ```shell
  curl -OL https://golang.org/dl/go1.17.9.linux-amd64.tar.gz
  ```
* Extract the download go files and packages in `/usr/local/go`
  ```shell
  sudo tar -C /usr/local -xvf go1.17.9.linux-amd64.tar.gz
  ```

* Export Environment Variables & Export PATH for GO.
  ```shell
  echo "export GOPATH=\"\$HOME/.go\"" >> ~/.bashrc
  echo "export GOROOT=\"/usr/local/go\"" >> ~/.bashrc
  echo "export PATH=\"\$PATH:\$GOPATH/bin:\$GOROOT/bin\"" >> ~/.bashrc
  ```

### Clone repository
  ``` shell
  git clone https://github.com/AssetMantle/node.git
  cd node
  git checkout tags/v0.3.0
  ```

# Make binary
  ```shell
  make install
  ```

# Verify version
  ```shell
  mantleNode version
  ```
  > NOTE: Plese make sure the output of this command is  HEAD-5b2b0dcb37b107b0e0c1eaf9e907aa9f1a1992d9

- Worried about typing? Below is a one-liner to install the mantleNode.

> curl -fsSL https://raw.githubusercontent.com/AssetMantle/genesisTransactions/main/mantle-1/install-node.bash | bash -i -

<a name="genesis-validator"></a>
## Pre Genesis Validator Setup

> Make sure you installed everything from go to mantleNode.

### Initialize the genesis.json file.
  ```shell
  mantleNode init <your-moniker-name> --chain-id mantle-1
  ```

### Create an account 
  ```shell
  # <key-name> is name of your account
  mantleNode keys add <key-name>
  ```

* If you want to recover your keys with `seeds or mnemonics`
  ```shell
  # Regenerate keys with your BIP39 mnemonics
  mantleNode keys add <key-name> --recover
  ```

* Or, if you want to import your keys with private keyfile
  ```shell
  mantleNode keys import <name> <key-file>
  ```

### Add keys into the `genesis.app_state.accounts` array in genesis.json
  ```shell
  mantleNode add-genesis-account <key-name> 1000000000umntl
  ```

### Create a transaction that creates your validator

  ```shell
  mantleNode gentx <key-name> 1000000000umntl \
  --chain-id mantle-1 \
  --moniker="<your-moniker-name>" \
  --commission-rate="0.02" \
  --commission-max-rate="0.5" \
  --commission-max-change-rate="0.02" \
  --details="<details for your validator" \
  --security-contact="<your email goes here>" \
  --website="<your website>" \
  --identity="<keybase identity>" \
  ```

### Submit PR
* Fork this Repository of [genesisTransactions](https://github.com/AssetMantle/genesisTransactions).
* Copy the whole contents of `$HOME/.mantleNode/config/gentx/gentx-xxxxx.json`
* Create a file `gentx-<validator-name>.json` under the `mantle-1/gentxs` folder in the forked repository. Paste the copied `$HOME/.mantleNode/config/gentx/gentx-xxxxx.json` contents into the created file `gentx-<validator-name>.json`.
* Run `mantleNode tendermint show-node-id` and copy the node-id.
* Next step is to identify your public reachable IP Address. Make sure your tendermint port (26656) is open and should be reachable from other nodes. For that type `curl ipinfo.io/ip`.
* Create a file `peers-<validator-name>.json` under the `mantle-1/peers` folder in the forked repository. Paste the copied node-id and public reachable IP address with tendermint port. Please refer below example.
```shell
0c31c03009cfb77d83c9649354408ea73be7f913@123.12.12.01:26656
```
* Create a Pull Request to the [main](https://github.com/AssetMantle/genesisTransactions) branch of the repository.
> **NOTE:** Pull Request will be merged by the maintainers to confirm the inclusion of the validator at the genesis.The final genesis file will be published under the file `mantle-1/final_genesis.json`.
* Genesis file hash can be verified by ` sha256sum ./mantle-1/final_genesis.json`. Hash is `49262b292ca0a8a97d605b6100ee17683f305bc707c7180ee044def47c85fff8`
* Replace the contents of your `$HOME/.mantleNode/config/genesis.json` with that of `mantle-1/final_genesis.json`.
* Add `persistent_peers` or `seeds` in `$HOME/.mantleNode/config/config.toml` from `mantle-1/final_peers.json` .

## Node Operation
It is recommended to use a service manager to run mantleNode. To setup system service, We need to create a file, for that please run this command in your terminal. `sudo touch /etc/systemd/system/mantle.service` and paste the below contents in the **mantle.service** file. Feel free to edit this system service file, as per your need.
```
[Unit]
Description=MantleNode
Requires=network-online.target
After=network-online.target

[Service]
User=ubuntu
Restart=on-failure
RestartSec=3
MemoryDenyWriteExecute=yes
LimitNOFILE=65535
ExecStart=/home/ubuntu/.go/bin/mantleNode --home=/home/ubuntu/.mantleNode start --x-crisis-skip-assert-invariants

[Install]
WantedBy=multi-user.target
```
* Now enable & start this via systemctl.
```shell
sudo systemctl daemon-reload
sudo systemctl enable mantle.service
sudo systemctl start mantle.service
```
* Looking for logs of **mantle.service?**
> journalctl -u mantle.service -f
* You can, also use tmux or screen (not recommended).
* Start the mantleNode, if you haven't created the service manager file.
```shell
mantleNode start --x-crisis-skip-assert-invariants
```


## Binary
The binary can be downloaded from [here](https://github.com/AssetMantle/node/releases/tag/v0.3.0).

## Explorer
The explorer for this chain will be hosted [here](https://explorer.assetmantle.one) after the chain goes live.

## Wallet
The wallet application for this chain will be hosted [here](https://wallet.assetmantle.one).

## Genesis Time
The genesis transactions sent before 1200HRS UTC 18th April 2022 will be used to publish the final_genesis.json at 1300HRS UTC 18th April 2022. The genesis block will be minted as soon as a quorum is reached.
