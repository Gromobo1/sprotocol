#!/bin/bash

log() {
    echo -e "\e[1;32m$1\e[0m"
}

log "Downloading snapshots"

sudo systemctl stop story-geth
sudo systemctl stop story

cd $HOME
rm -f Story_snapshot.lz4
aria2c -x 16 -s 16 -k 1M https://story.josephtran.co/Story_snapshot.lz4

rm -f Geth_snapshot.lz4
aria2c -x 16 -s 16 -k 1M https://story.josephtran.co/Geth_snapshot.lz4

cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/priv_validator_state.json.backup
rm -rf $HOME/.story/story/data
rm -rf $HOME/.story/geth/iliad/geth/chaindata

sudo mkdir -p $HOME/.story/story/data
lz4 -d -c Story_snapshot.lz4 | pv | sudo tar xv -C $HOME/.story/story/ > /dev/null
cp $HOME/.story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json

sudo mkdir -p $HOME/.story/geth/iliad/geth/chaindata
lz4 -d -c Geth_snapshot.lz4 | pv | sudo tar xv -C $HOME/.story/geth/iliad/geth/ > /dev/null

log "Starting node"

sudo systemctl start story-geth
sudo systemctl start story
