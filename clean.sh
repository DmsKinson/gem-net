#!/bin/bash

# Remove CA material in cli/peers, orderer, consumer, dealer, producer, accreditor
removeCA(){
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
}


# Remove docker images
removeImages(){
    local LOCAL_IMAGES=$(docker images | awk '{print $1}' | uniq)
    local TARGETS=(consumer-peer consumer-ca accreditor-peer accreditor-ca dealer-peer dealer-ca producer-peer producer-ca orderer)
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

removeCA
removeImages