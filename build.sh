#!/bin/bash

export FABRIC_CFG_PATH=$PWD
bash ./clean.sh
bash ./generate-certs.sh
bash ./docker-images.sh
sleep 5
docker-compose up -d
