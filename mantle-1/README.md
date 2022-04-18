# Documentation

[TOC]

## Hardware Requirements
| Minimum Requirement | Recommended Requirement |
| ------------------- | ----------------------- |
| v2 CPUs             | v4 CPUs                 |
| 4GB RAM             | 8GB RAM                 |
| 200GB SSD           | 500GB SSD               |

## Installation of MantleNode

- Update & Upgrade your system packages.

  ```shell
  sudo apt-get update && sudo apt-get upgrade -y
  ```

- Install few essential packages.

  ```shell
  sudo apt-get install build-essential git -y
  ```

- Download Go version 1.17.9 , ref - [go's official website](https://go.dev/dl/).

  ```shell
  curl -OL https://golang.org/dl/go1.17.9.linux-amd64.tar.gz
  ```

- Extract the download go files and packages in `/usr/local/go`

  ```shell
  sudo tar -C /usr/local -xvf go1.17.9.linux-amd64.tar.gz
  ```

- Export Environment Variables & Export PATH for GO.

  ```shell
  echo "export GOPATH=\"\$HOME/.go\"" >> ~/.bashrc
  echo "export GOROOT=\"/usr/local/go\"" >> ~/.bashrc
  echo "export PATH=\"\$PATH:\$GOPATH/bin:\$GOROOT/bin\"" >> ~/.bashrc
  ```

- Clone the repository of MantleNode

  ```shell
  git clone https://github.com/AssetMantle/node.git
  cd node
  git checkout tags/v0.3.0
  ```

- Install dependencies & make mantleNode binary

  ```shell
  cd node && make install
  ```

- Verify the MantleNode version

  ```shell
  mantleNode version
  ```

## Pre Genesis Validator Setup

> Make sure you installed everything from go to mantleNode.

- Initialize the genesis.json file.

  ```shell
  mantleNode init <your-moniker-name> --chain-id mantle-1
  ```

- Create an account for your validator

  ```shell
  # <key-name> is name of your account
  mantleNode keys add <key-name>
  ```

- If you want to recover your keys with `seeds or mnemonics`

  ```shell
  # Regenerate keys with your BIP39 mnemonics
  mantleNode keys add <key-name> --recover
  ```

- Or, if you want to import your keys with private keyfile

  ```shell
  mantleNode keys import <name> <key-file>
  ```

- Add keys into the `genesis.app_state.accounts` array in genesis.json

  ```shell
  mantleNode add-genesis-account <key-name> 1000000000umntl
  ```

- Create a transaction that creates your validator

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

- Fork this Repository of [genesisTransactions](https://github.com/AssetMantle/genesisTransactions).

- Copy the whole contents of `$HOME/.mantleNode/config/gentx/gentx-xxxxx.json`

- Create a file `gentx-<validator-name>.json` under the `mantle-1/gentxs` folder in the forked repository. Paste the copied `$HOME/.mantleNode/config/gentx/gentx-xxxxx.json` contents into the created file `gentx-<validator-name>.json`.

- Run `mantleNode tendermint show-node-id` and copy the node-id.

- Next step is to identify your public reachable IP Address. Make sure your tendermint port (26656) is open and should be reachable from other nodes. For that type `curl ipinfo.io/ip`.

- Create a file `peers-<validator-name>.json` under the `mantle-1/peers` folder in the forked repository. Paste the copied node-id and public reachable IP address with tendermint port. Please refer below example.

```shell
0c31c03009cfb77d83c9649354408ea73be7f913@123.12.12.01:26656
```

- Create a Pull Request to the [main](https://github.com/AssetMantle/genesisTransactions) branch of the repository.

> **NOTE:** Pull Request will be merged by the maintainers to confirm the inclusion of the validator at the genesis.The final genesis file will be published under the file `mantle-1/final_genesis.json`.

- Replace the contents of your `$HOME/.mantleNode/config/genesis.json` with that of `mantle-1/final_genesis.json`.
- Add `persistent_peers` or `seeds` in `$HOME/.mantleNode/config/config.toml` from `mantle-1/final_peers.json` .
- Start the mantleNode.

```shell
mantleNode start
```

