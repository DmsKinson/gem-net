#!/bin/bash

CHANNEL_NAME="gem-net"
PROJPATH=$(pwd)
CRYPTO=$PROJPATH/crypto

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsGenesis -outputBlock $CRYPTO/genesis.block

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
