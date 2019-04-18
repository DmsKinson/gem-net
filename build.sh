#!/bin/bash

export FABRIC_CFG_PATH=$PWD
bash ./clean.sh
bash ./generate-certs.sh
bash ./generate-cfgtx.sh
bash ./docker-images.sh
sleep 5
docker-compose up -d

# docker exec orderer peer channel create -o orderer:7050 -c gem-channel -f /orderer/crypto/channel.tx --tls true --cafile /orderer/crypto/
