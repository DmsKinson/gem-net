#!/bin/bash
set -u

# Pull images that local don't have
dockerPull(){
    # Create a list filling with images that already exist
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

    echo '############################################################'
    echo '#                 BUILDING CONTAINER IMAGES                #'
    echo '############################################################'
    docker build -t orderer:latest orderer/
    docker build -t insurance-peer:latest insurancePeer/
    docker build -t police-peer:latest policePeer/
    docker build -t shop-peer:latest shopPeer/
    docker build -t repairshop-peer:latest repairShopPeer/
    docker build -t web:latest web/
    docker build -t insurance-ca:latest insuranceCA/
    docker build -t police-ca:latest policeCA/
    docker build -t shop-ca:latest shopCA/
    docker build -t repairshop-ca:latest repairShopCA/
