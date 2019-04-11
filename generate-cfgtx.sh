#!/bin/sh

CHANNEL_NAME="gem-net"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsGenesis -outputBlock $CLIPATH/genesis.block

echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputCreateChannelTx $CLIPATH/channel.tx -channelID $CHANNEL_NAME
# cp $CLIPATH/channel.tx $PROJPATH/web
echo
echo "#################################################################"
echo "####### Generating anchor peer update for ProducerOrg ##########"
echo "#################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/ProducerOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg ProducerOrgMSP

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for DealerOrg   ##########"
echo "#################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/DealerOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg DealerOrgMSP

echo
echo "##################################################################"
echo "####### Generating anchor peer update for ConsumerOrg ##########"
echo "##################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/ConsumerOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg ConsumerOrgMSP

echo
echo "##################################################################"
echo "#######   Generating anchor peer update for AccreditorOrg   ##########"
echo "##################################################################"
$PROJPATH/bin/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/AccreditorOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg AccreditorOrgMSP
