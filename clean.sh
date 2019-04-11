#!/bin/sh

set -e

# Delete cli
if [ -e cli/peers ] 
then
    rm -rf cli
fi

for DIR in consumer dealer producer accreditor
do
    if [ -e ${DIR}Peer/crypto ] 
    then
        rm -rf ${DIR}Peer/crypto
    fi
   
    if [ -e ${DIR}CA/ca ] 
    then
        rm -rf ${DIR}CA/ca
    fi
   
    if [ -e ${DIR}CA/tls ] 
    then
        rm -rf ${DIR}CA/tls
    fi
done