#!/bin/bash
cp ./bin/* .
export FABRIC_CFG_PATH=$PWD
sh ./generate-certs.sh
sh ./docker-images.sh
sleep 5
docker-compose up -d
