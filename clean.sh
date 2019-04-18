#!/bin/bash

# Remove Crypto material in cli/peers, orderer, consumer, dealer, producer, accreditor
removeCrypto(){
    if [ -e crypto ] 
    then
        rm -rf crypto
    fi
    rm -rf images/CA/*ca
    rm -rf images/peer/*-crypto
    rm -rf images/orderer/crypto
}


# Remove docker images
removeImages(){
    local LOCAL_IMAGES=$(docker images | awk '{print $1}' | uniq)
    local TARGETS=(consumer-peer consumer-ca accreditor-peer accreditor-ca dealer-peer dealer-ca producer-peer producer-ca orderer)
    docker-compose down 
    for IMAGE in ${TARGETS[@]} 
    do
        echo $LOCAL_IMAGES | grep $IMAGE  > /dev/null
        if [ $? -eq 0 ] ;then
            echo "Removing $IMAGE"
            docker stop ${IMAGE}
            docker rm ${IMAGE}
            docker rmi  $IMAGE
        fi
    done
    docker container prune -f
}

removeCrypto
removeImages