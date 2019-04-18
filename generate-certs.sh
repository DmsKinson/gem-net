#!/bin/bash
set -e

echo
echo "#################################################################"
echo "#######        Generating cryptographic material       ##########"
echo "#################################################################"
PROJPATH=$(pwd)
CHANNEL_NAME="gem-channel"
CRYPTO=$PROJPATH/crypto
ORDERERS=$CRYPTO/ordererOrganizations
PEERS=$CRYPTO/peerOrganizations

rm -rf $CRYPTO
$PROJPATH/bin/cryptogen generate --config=$PROJPATH/crypto-config.yaml --output=$CRYPTO

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsGenesis -channelID $CHANNEL_NAME  -outputBlock $CRYPTO/genesis.block

echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputCreateChannelTx $CRYPTO/channel.tx -channelID $CHANNEL_NAME
# cp $CRYPTO/channel.tx $PROJPATH/web
echo
echo "#################################################################"
echo "####### Generating anchor peer update for ProducerOrg ##########"
echo "#################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CRYPTO/ProducerOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg ProducerOrgMSP

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for DealerOrg   ##########"
echo "#################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CRYPTO/DealerOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg DealerOrgMSP

echo
echo "##################################################################"
echo "####### Generating anchor peer update for ConsumerOrg ##########"
echo "##################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CRYPTO/ConsumerOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg ConsumerOrgMSP

echo
echo "##################################################################"
echo "#######   Generating anchor peer update for AccreditorOrg   ##########"
echo "##################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CRYPTO/AccreditorOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg AccreditorOrgMSP

for PEER in producer accreditor consumer dealer;
do
    mkdir -p $PROJPATH/images/peer/${PEER}-crypto
    cp -r crypto/peerOrganizations/${PEER}-org/peers/${PEER}-peer/* $PROJPATH/images/peer/${PEER}-crypto
    cp crypto/genesis.block images/peer/${PEER}-crypto/
    cp crypto/channel.tx images/peer/${PEER}-crypto/
    mkdir -p $PROJPATH/images/CA/${PEER}-ca
    mkdir -p $PROJPATH/images/CA/${PEER}-tlsca
    cp crypto/peerOrganizations/${PEER}-org/ca/*_sk $PROJPATH/images/CA/${PEER}-ca/key.pem
    cp crypto/peerOrganizations/${PEER}-org/ca/*.pem $PROJPATH/images/CA/${PEER}-ca/cert.pem
    cp crypto/peerOrganizations/${PEER}-org/tlsca/*_sk $PROJPATH/images/CA/${PEER}-tlsca/key.pem
    cp crypto/peerOrganizations/${PEER}-org/tlsca/*.pem $PROJPATH/images/CA/${PEER}-tlsca/cert.pem
done

mkdir -p $PROJPATH/images/orderer/crypto
cp -r crypto/channel.tx $PROJPATH/images/orderer/crypto
cp -r crypto/genesis.block $PROJPATH/images/orderer/crypto
cp -r crypto/ordererOrganizations/orderer-org/orderers/orderer/* $PROJPATH/images/orderer/crypto
# bash generate-cfgtx.sh

# # rm -rf $PROJPATH/{orderer,producerPeer,accreditorPeer,consumerPeer,dealerPeer}/crypto
# rm -rf $PROJPATH/orderer/crypto
# rm -rf $PROJPATH/producerPeer/crypto
# rm -rf $PROJPATH/accreditorPeer/crypto
# rm -rf $PROJPATH/consumerPeer/crypto
# rm -rf $PROJPATH/dealerPeer/crypto
# # mkdir $PROJPATH/{orderer,producerPeer,accreditorPeer,consumerPeer,dealerPeer}/crypto
# mkdir $PROJPATH/orderer/crypto
# mkdir $PROJPATH/producerPeer/crypto
# mkdir $PROJPATH/accreditorPeer/crypto
# mkdir $PROJPATH/consumerPeer/crypto
# mkdir $PROJPATH/dealerPeer/crypto
# # cp -r $ORDERERS/orderer-org/orderers/orderer/{msp,tls} $PROJPATH/orderer/crypto
# cp -r $ORDERERS/orderer-org/orderers/orderer/msp $PROJPATH/orderer/crypto
# cp -r $ORDERERS/orderer-org/orderers/orderer/tls $PROJPATH/orderer/crypto
# # cp -r $PEERS/producer-org/peers/producer-peer/{msp,tls} $PROJPATH/producerPeer/crypto
# cp -r $PEERS/producer-org/peers/producer-peer/msp $PROJPATH/producerPeer/crypto
# cp -r $PEERS/producer-org/peers/producer-peer/tls $PROJPATH/producerPeer/crypto
# # cp -r $PEERS/accreditor-org/peers/accreditor-peer/{msp,tls} $PROJPATH/accreditorPeer/crypto
# cp -r $PEERS/accreditor-org/peers/accreditor-peer/msp $PROJPATH/accreditorPeer/crypto
# cp -r $PEERS/accreditor-org/peers/accreditor-peer/tls $PROJPATH/accreditorPeer/crypto
# # cp -r $PEERS/consumer-org/peers/consumer-peer/{msp,tls} $PROJPATH/consumerPeer/crypto
# cp -r $PEERS/consumer-org/peers/consumer-peer/msp $PROJPATH/consumerPeer/crypto
# cp -r $PEERS/consumer-org/peers/consumer-peer/tls $PROJPATH/consumerPeer/crypto
# # cp -r $PEERS/dealer-org/peers/dealer-peer/{msp,tls} $PROJPATH/dealerPeer/crypto
# cp -r $PEERS/dealer-org/peers/dealer-peer/msp $PROJPATH/dealerPeer/crypto
# cp -r $PEERS/dealer-org/peers/dealer-peer/tls $PROJPATH/dealerPeer/crypto

# cp $CRYPTO/genesis.block $PROJPATH/orderer/crypto/

# PRODUCERCAPATH=$PROJPATH/producerCA
# ACCREDITORCAPATH=$PROJPATH/accreditorCA
# CONSUMERCAPATH=$PROJPATH/consumerCA
# DEALERCAPATH=$PROJPATH/dealerCA

# # rm -rf {$PRODUCERCAPATH,$ACCREDITORCAPATH,$CONSUMERCAPATH,$DEALERCAPATH}/{ca,tls}
# rm -rf $PRODUCERCAPATH/ca
# rm -rf $ACCREDITORCAPATH/ca
# rm -rf $CONSUMERCAPATH/ca
# rm -rf $DEALERCAPATH/ca
# rm -rf $PRODUCERCAPATH/tls
# rm -rf $ACCREDITORCAPATH/tls
# rm -rf $CONSUMERCAPATH/tls
# rm -rf $DEALERCAPATH/tls
# # mkdir -p {$PRODUCERCAPATH,$ACCREDITORCAPATH,$CONSUMERCAPATH,$DEALERCAPATH}/{ca,tls}
# mkdir -p $PRODUCERCAPATH/ca
# mkdir -p $ACCREDITORCAPATH/ca
# mkdir -p $CONSUMERCAPATH/ca
# mkdir -p $DEALERCAPATH/ca
# mkdir -p $PRODUCERCAPATH/tls
# mkdir -p $ACCREDITORCAPATH/tls
# mkdir -p $CONSUMERCAPATH/tls
# mkdir -p $DEALERCAPATH/tls
# cp $PEERS/producer-org/ca/* $PRODUCERCAPATH/ca
# cp $PEERS/producer-org/tlsca/* $PRODUCERCAPATH/tls
# mv $PRODUCERCAPATH/ca/*_sk $PRODUCERCAPATH/ca/key.pem
# mv $PRODUCERCAPATH/ca/*-cert.pem $PRODUCERCAPATH/ca/cert.pem
# mv $PRODUCERCAPATH/tls/*_sk $PRODUCERCAPATH/tls/key.pem
# mv $PRODUCERCAPATH/tls/*-cert.pem $PRODUCERCAPATH/tls/cert.pem

# cp $PEERS/accreditor-org/ca/* $ACCREDITORCAPATH/ca
# cp $PEERS/accreditor-org/tlsca/* $ACCREDITORCAPATH/tls
# mv $ACCREDITORCAPATH/ca/*_sk $ACCREDITORCAPATH/ca/key.pem
# mv $ACCREDITORCAPATH/ca/*-cert.pem $ACCREDITORCAPATH/ca/cert.pem
# mv $ACCREDITORCAPATH/tls/*_sk $ACCREDITORCAPATH/tls/key.pem
# mv $ACCREDITORCAPATH/tls/*-cert.pem $ACCREDITORCAPATH/tls/cert.pem

# cp $PEERS/consumer-org/ca/* $CONSUMERCAPATH/ca
# cp $PEERS/consumer-org/tlsca/* $CONSUMERCAPATH/tls
# mv $CONSUMERCAPATH/ca/*_sk $CONSUMERCAPATH/ca/key.pem
# mv $CONSUMERCAPATH/ca/*-cert.pem $CONSUMERCAPATH/ca/cert.pem
# mv $CONSUMERCAPATH/tls/*_sk $CONSUMERCAPATH/tls/key.pem
# mv $CONSUMERCAPATH/tls/*-cert.pem $CONSUMERCAPATH/tls/cert.pem

# cp $PEERS/dealer-org/ca/* $DEALERCAPATH/ca
# cp $PEERS/dealer-org/tlsca/* $DEALERCAPATH/tls
# mv $DEALERCAPATH/ca/*_sk $DEALERCAPATH/ca/key.pem
# mv $DEALERCAPATH/ca/*-cert.pem $DEALERCAPATH/ca/cert.pem
# mv $DEALERCAPATH/tls/*_sk $DEALERCAPATH/tls/key.pem
# mv $DEALERCAPATH/tls/*-cert.pem $DEALERCAPATH/tls/cert.pem
