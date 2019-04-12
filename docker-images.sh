#!/bin/bash
set -u
# Pull images that local don't have
dockerPull(){
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

# # Exit when error occurs
set -e

dockerPull
echo '############################################################'
echo '#                 BUILDING CONTAINER IMAGES                #'
echo '############################################################'
docker build -t orderer:latest orderer/
docker build -t producer-peer:latest producerPeer/
docker build -t accreditor-peer:latest accreditorPeer/
docker build -t dealer-peer:latest dealerPeer/
docker build -t consumer-peer:latest consumerPeer/
# docker build -t web:latest web/
docker build -t producer-ca:latest producerCA/
docker build -t accreditor-ca:latest accreditorCA/
docker build -t dealer-ca:latest dealerCA/
docker build -t consumer-ca:latest consumerCA/
