#!/bin/sh
set -e

echo
echo "#################################################################"
echo "#######        Generating cryptographic material       ##########"
echo "#################################################################"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers
ORDERERS=$CLIPATH/ordererOrganizations
PEERS=$CLIPATH/peerOrganizations

rm -rf $CLIPATH
$PROJPATH/cryptogen generate --config=$PROJPATH/crypto-config.yaml --output=$CLIPATH

sh generate-cfgtx.sh

# rm -rf $PROJPATH/{orderer,producerPeer,accreditorPeer,repairShopPeer,dealerPeer}/crypto
rm -rf $PROJPATH/orderer/crypto
rm -rf $PROJPATH/producerPeer/crypto
rm -rf $PROJPATH/accreditorPeer/crypto
rm -rf $PROJPATH/repairShopPeer/crypto
rm -rf $PROJPATH/dealerPeer/crypto
# mkdir $PROJPATH/{orderer,producerPeer,accreditorPeer,repairShopPeer,dealerPeer}/crypto
mkdir $PROJPATH/orderer/crypto
mkdir $PROJPATH/producerPeer/crypto
mkdir $PROJPATH/accreditorPeer/crypto
mkdir $PROJPATH/repairShopPeer/crypto
mkdir $PROJPATH/dealerPeer/crypto
# cp -r $ORDERERS/orderer-org/orderers/orderer0/{msp,tls} $PROJPATH/orderer/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/msp $PROJPATH/orderer/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/tls $PROJPATH/orderer/crypto
# cp -r $PEERS/producer-org/peers/producer-peer/{msp,tls} $PROJPATH/producerPeer/crypto
cp -r $PEERS/producer-org/peers/producer-peer/msp $PROJPATH/producerPeer/crypto
cp -r $PEERS/producer-org/peers/producer-peer/tls $PROJPATH/producerPeer/crypto
# cp -r $PEERS/accreditor-org/peers/accreditor-peer/{msp,tls} $PROJPATH/accreditorPeer/crypto
cp -r $PEERS/accreditor-org/peers/accreditor-peer/msp $PROJPATH/accreditorPeer/crypto
cp -r $PEERS/accreditor-org/peers/accreditor-peer/tls $PROJPATH/accreditorPeer/crypto
# cp -r $PEERS/repairdealer-org/peers/repairdealer-peer/{msp,tls} $PROJPATH/repairShopPeer/crypto
cp -r $PEERS/repairdealer-org/peers/repairdealer-peer/msp $PROJPATH/repairShopPeer/crypto
cp -r $PEERS/repairdealer-org/peers/repairdealer-peer/tls $PROJPATH/repairShopPeer/crypto
# cp -r $PEERS/dealer-org/peers/dealer-peer/{msp,tls} $PROJPATH/dealerPeer/crypto
cp -r $PEERS/dealer-org/peers/dealer-peer/msp $PROJPATH/dealerPeer/crypto
cp -r $PEERS/dealer-org/peers/dealer-peer/tls $PROJPATH/dealerPeer/crypto
cp $CLIPATH/genesis.block $PROJPATH/orderer/crypto/

PRODUCERCAPATH=$PROJPATH/producerCA
ACCREDITORCAPATH=$PROJPATH/accreditorCA
CONSUMERCAPATH=$PROJPATH/repairShopCA
DEALERCAPATH=$PROJPATH/dealerCA

# rm -rf {$PRODUCERCAPATH,$ACCREDITORCAPATH,$CONSUMERCAPATH,$DEALERCAPATH}/{ca,tls}
rm -rf $PRODUCERCAPATH/ca
rm -rf $ACCREDITORCAPATH/ca
rm -rf $CONSUMERCAPATH/ca
rm -rf $DEALERCAPATH/ca
rm -rf $PRODUCERCAPATH/tls
rm -rf $ACCREDITORCAPATH/tls
rm -rf $CONSUMERCAPATH/tls
rm -rf $DEALERCAPATH/tls
# mkdir -p {$PRODUCERCAPATH,$ACCREDITORCAPATH,$CONSUMERCAPATH,$DEALERCAPATH}/{ca,tls}
mkdir -p $PRODUCERCAPATH/ca
mkdir -p $ACCREDITORCAPATH/ca
mkdir -p $CONSUMERCAPATH/ca
mkdir -p $DEALERCAPATH/ca
mkdir -p $PRODUCERCAPATH/tls
mkdir -p $ACCREDITORCAPATH/tls
mkdir -p $CONSUMERCAPATH/tls
mkdir -p $DEALERCAPATH/tls
cp $PEERS/producer-org/ca/* $PRODUCERCAPATH/ca
cp $PEERS/producer-org/tlsca/* $PRODUCERCAPATH/tls
mv $PRODUCERCAPATH/ca/*_sk $PRODUCERCAPATH/ca/key.pem
mv $PRODUCERCAPATH/ca/*-cert.pem $PRODUCERCAPATH/ca/cert.pem
mv $PRODUCERCAPATH/tls/*_sk $PRODUCERCAPATH/tls/key.pem
mv $PRODUCERCAPATH/tls/*-cert.pem $PRODUCERCAPATH/tls/cert.pem

cp $PEERS/accreditor-org/ca/* $ACCREDITORCAPATH/ca
cp $PEERS/accreditor-org/tlsca/* $ACCREDITORCAPATH/tls
mv $ACCREDITORCAPATH/ca/*_sk $ACCREDITORCAPATH/ca/key.pem
mv $ACCREDITORCAPATH/ca/*-cert.pem $ACCREDITORCAPATH/ca/cert.pem
mv $ACCREDITORCAPATH/tls/*_sk $ACCREDITORCAPATH/tls/key.pem
mv $ACCREDITORCAPATH/tls/*-cert.pem $ACCREDITORCAPATH/tls/cert.pem

cp $PEERS/repairdealer-org/ca/* $CONSUMERCAPATH/ca
cp $PEERS/repairdealer-org/tlsca/* $CONSUMERCAPATH/tls
mv $CONSUMERCAPATH/ca/*_sk $CONSUMERCAPATH/ca/key.pem
mv $CONSUMERCAPATH/ca/*-cert.pem $CONSUMERCAPATH/ca/cert.pem
mv $CONSUMERCAPATH/tls/*_sk $CONSUMERCAPATH/tls/key.pem
mv $CONSUMERCAPATH/tls/*-cert.pem $CONSUMERCAPATH/tls/cert.pem

cp $PEERS/dealer-org/ca/* $DEALERCAPATH/ca
cp $PEERS/dealer-org/tlsca/* $DEALERCAPATH/tls
mv $DEALERCAPATH/ca/*_sk $DEALERCAPATH/ca/key.pem
mv $DEALERCAPATH/ca/*-cert.pem $DEALERCAPATH/ca/cert.pem
mv $DEALERCAPATH/tls/*_sk $DEALERCAPATH/tls/key.pem
mv $DEALERCAPATH/tls/*-cert.pem $DEALERCAPATH/tls/cert.pem
