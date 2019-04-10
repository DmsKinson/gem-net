#!/bin/sh
# Exit when error occurs
set -e

echo
echo "#################################################################"
echo "#######        Generating cryptographic material       ##########"
echo "#################################################################"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers
ORDERERS=$CLIPATH/ordererOrganizations
PEERS=$CLIPATH/peerOrganizations
PEERS_DIR={orderer,producerPeer,accreditorPeer,consumerPeer,dealerPeer}

rm -rf $CLIPATH
$PROJPATH/cryptogen generate --config=$PROJPATH/crypto-config.yaml --output=$CLIPATH

sh generate-cfgtx.sh

rm -rf $PROJPATH/{$PEERS_DIR}
rm -rf $PROJPATH/{orderer,producerPeer,accreditorPeer,consumerPeer,dealerPeer}/crypto
mkdir $PROJPATH/{orderer,producerPeer,accreditorPeer,consumerPeer,dealerPeer}/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer/{msp,tls} $PROJPATH/orderer/crypto
cp -r $PEERS/producer-org/peers/producer-peer/{msp,tls} $PROJPATH/producerPeer/crypto
cp -r $PEERS/consumer-org/peers/consumer-peer/{msp,tls} $PROJPATH/consumerPeer/crypto
cp -r $PEERS/dealer-org/peers/dealer-peer/{msp,tls} $PROJPATH/dealerPeer/crypto
cp -r $PEERS/accreditor-org/peers/accreditor-peer/{msp,tls} $PROJPATH/accreditorPeer/crypto
cp $CLIPATH/genesis.block $PROJPATH/orderer/crypto/


PRODUCERPATH=$PROJPATH/producerCA
ACCREDITOERPATH=$PROJPATH/accreditorCA
CONSUMERPATH=$PROJPATH/consumerCA
DEALERPATH=$PROJPATH/dealerCA

rm -rf {$PRODUCERPATH,$ACCREDITOERPATH,$CONSUMERPATH,$DEALERPATH}/{ca,tls}
mkdir -p {$PRODUCERPATH,$ACCREDITOERPATH,$CONSUMERPATH,$DEALERPATH}/{ca,tls}
cp $PEERS/producer-org/ca/* $PRODUCERPATH/ca
cp $PEERS/producer-org/tlsca/* $PRODUCERPATH/tls
mv $PRODUCERPATH/ca/*_sk $PRODUCERPATH/ca/key.pem
mv $PRODUCERPATH/ca/*-cert.pem $PRODUCERPATH/ca/cert.pem
mv $PRODUCERPATH/tls/*_sk $PRODUCERPATH/tls/key.pem
mv $PRODUCERPATH/tls/*-cert.pem $PRODUCERPATH/tls/cert.pem

cp $PEERS/accreditor-org/ca/* $ACCREDITOERPATH/ca
cp $PEERS/accreditor-org/tlsca/* $ACCREDITOERPATH/tls
mv $ACCREDITOERPATH/ca/*_sk $ACCREDITOERPATH/ca/key.pem
mv $ACCREDITOERPATH/ca/*-cert.pem $ACCREDITOERPATH/ca/cert.pem
mv $ACCREDITOERPATH/tls/*_sk $ACCREDITOERPATH/tls/key.pem
mv $ACCREDITOERPATH/tls/*-cert.pem $ACCREDITOERPATH/tls/cert.pem

cp $PEERS/dealer-org/ca/* $CONSUMERPATH/ca
cp $PEERS/dealer-org/tlsca/* $CONSUMERPATH/tls
mv $CONSUMERPATH/ca/*_sk $CONSUMERPATH/ca/key.pem
mv $CONSUMERPATH/ca/*-cert.pem $CONSUMERPATH/ca/cert.pem
mv $CONSUMERPATH/tls/*_sk $CONSUMERPATH/tls/key.pem
mv $CONSUMERPATH/tls/*-cert.pem $CONSUMERPATH/tls/cert.pem

cp $PEERS/accreditor-org/ca/* $DEALERPATH/ca
cp $PEERS/accreditor-org/tlsca/* $DEALERPATH/tls
mv $DEALERPATH/ca/*_sk $DEALERPATH/ca/key.pem
mv $DEALERPATH/ca/*-cert.pem $DEALERPATH/ca/cert.pem
mv $DEALERPATH/tls/*_sk $DEALERPATH/tls/key.pem
mv $DEALERPATH/tls/*-cert.pem $DEALERPATH/tls/cert.pem

# WEBCERTS=$PROJPATH/web/certs
# rm -rf $WEBCERTS
# mkdir -p $WEBCERTS
# cp $PROJPATH/orderer/crypto/tls/ca.crt $WEBCERTS/ordererOrg.pem
# cp $PROJPATH/producerPeer/crypto/tls/ca.crt $WEBCERTS/producerOrg.pem
# cp $PROJPATH/accreditorPeer/crypto/tls/ca.crt $WEBCERTS/accreditorOrg.pem
# cp $PROJPATH/consumerPeer/crypto/tls/ca.crt $WEBCERTS/consumerOrg.pem
# cp $PROJPATH/accreditorPeer/crypto/tls/ca.crt $WEBCERTS/accreditorOrg.pem
# cp $PEERS/producer-org/users/Admin@producer-org/msp/keystore/* $WEBCERTS/Admin@producer-org-key.pem
# cp $PEERS/producer-org/users/Admin@producer-org/msp/signcerts/* $WEBCERTS/
# cp $PEERS/accreditor-org/users/Admin@accreditor-org/msp/keystore/* $WEBCERTS/Admin@accreditor-org-key.pem
# cp $PEERS/accreditor-org/users/Admin@accreditor-org/msp/signcerts/* $WEBCERTS/
# cp $PEERS/accreditor-org/users/Admin@accreditor-org/msp/keystore/* $WEBCERTS/Admin@accreditor-org-key.pem
# cp $PEERS/accreditor-org/users/Admin@accreditor-org/msp/signcerts/* $WEBCERTS/
# cp $PEERS/dealer-org/users/Admin@dealer-org/msp/keystore/* $WEBCERTS/Admin@dealer-org-key.pem
# cp $PEERS/dealer-org/users/Admin@dealer-org/msp/signcerts/* $WEBCERTS/
