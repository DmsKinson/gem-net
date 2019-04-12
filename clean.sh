#!/bin/bash

# Remove CA material in cli/peers, orderer, consumer, dealer, producer, accreditor
if [ -e cli/peers ] 
then
    rm -rf cli/peers
fi

if [ -e orderer/crypto ] ; then
    rm -rf orderer/crypto;
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
# Remove docker images
removeImages(){
    local LOCAL_IMAGES=$(docker images | awk '{print $1}' | uniq)
    local TARGET_IMAGES=("orderer" "consumer-peer" "accreditor-peer" "dealer-peer" "producer-peer")

    for IMAGE in ${TARGET_IMAGES[@]} 
    do
        echo $LOCAL_IMAGES | grep $IMAGE  > /dev/null
        if [ $? -eq 0 ] ;then
            echo "Removing hyperledger/$IMAGE"
            docker stop $IMAGE
            docker rmi -f $IMAGE
        fi
    done
    docker container prune -f
}
