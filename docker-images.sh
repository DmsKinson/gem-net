#!/bin/bash
set -u

# Pull base images that local don't have
pullBaseImages(){
    # Create a list filling with images that already exist
    echo '############################################################'
    echo '#                 PULLING NON-EXIST IMAGES                 #'
    echo '############################################################'
    local LOCAL_IMAGES=$(docker images | awk '/hyperledger/{print $1}' | sed 's/hyperledger\///g' | uniq)
    local TARGET_IMAGES=(fabric-peer fabric-orderer fabric-ccenv fabric-ca)

    for IMAGE in ${TARGET_IMAGES[@]} 
    do
        echo $LOCAL_IMAGES | grep $IMAGE  > /dev/null
        if [ $? -ne 0 ] ;then
            echo "Download hyperledger/$IMAGE"
            docker pull hyperledger/$IMAGE
        fi
    done
}

buildImages(){
    echo '############################################################'
    echo '#                 BUILDING CONTAINER IMAGES                #'
    echo '############################################################'
    local PWD=$(pwd)
    echo "Building orderer images"
    docker build -t orderer:latest images/orderer
    # Create peer images
    for PEER in producer accreditor dealer consumer;
    do
        # Create peer images
        echo "Building ${PEER}-peer image..."
        cp -f images/peer/Dockerfile.in images/peer/Dockerfile
        sed -i -e "s#PEER#${PEER}#g" images/peer/Dockerfile
        docker build -t "${PEER}-peer" images/peer
        # Create CA images
        echo "Building ${PEER}-ca image..."
        cp -f images/CA/Dockerfile.in images/CA/Dockerfile
        sed -i "s#CA_NAME#${PEER}#g" images/CA/Dockerfile
        docker build -t "${PEER}-ca" images/CA
    done

    if [ -e images/peer/Dockerfile ]
    then
        rm images/peer/Dockerfile
    fi
    
    if [ -e images/CA/Dockerfile ]
    then
        rm images/CA/Dockerfile
    fi
    # # Create CA images
    # for CA in producer-ca accreditor-ca dealer-ca consumer-ca;
    # do
    #     # Replace name to create specific config 
    #     cp images/CA/config/fabric-ca-server-config.yaml images/CA
    #     sed -i "s/CA_NAME/${CA}/g" images/CA/fabric-ca-server-config.yaml > /dev/null
    #     docker build -t $CA images/CA
    # done
    
}

# Main
set -e
pullBaseImages
buildImages