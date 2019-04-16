#!/bin/bash
set -e

CORE_PEER_MSPCONFIGPATH=/peers/ordererOrganizations/orderer-org/orderers/orderer/msp CORE_PEER_LOCALMSPID="OrdererMSP" peer channel create -o orderer:7050 -c gem-channel -f /peers/orderer/channel.tx --tls true --cafile /peers/orderer/localMspConfig/cacerts/ordererOrg.pem

CORE_PEER_MSPCONFIGPATH=/peers/producerPeer/localMspConfig CORE_PEER_ADDRESS=producer-peer:7051 CORE_PEER_LOCALMSPID=ProducerOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/peers/producerPeer/localMspConfig/cacerts/producerOrg.pem peer channel join -b default.block

CORE_PEER_MSPCONFIGPATH=/peers/dealerPeer/localMspConfig CORE_PEER_ADDRESS=dealer-peer:7051 CORE_PEER_LOCALMSPID=DealerOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/peers/dealerPeer/localMspConfig/cacerts/dealerOrg.pem peer channel join -b default.block

CORE_PEER_MSPCONFIGPATH=/peers/consumerPeer/localMspConfig CORE_PEER_ADDRESS=consumer-peer:7051 CORE_PEER_LOCALMSPID=ConsumerOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/peers/consumerPeer/localMspConfig/cacerts/consumerOrg.pem peer channel join -b default.block

CORE_PEER_MSPCONFIGPATH=/peers/accreditorPeer/localMspConfig CORE_PEER_ADDRESS=accreditor-peer:7051 CORE_PEER_LOCALMSPID=AccreditorOrgMSP CORE_PEER_TLS_ROOTCERT_FILE/peers/accreditor/localMspConfig/cacerts/accreditorOrg.pem peer channel join -b default.block

## Don't use TLS
# CORE_PEER_MSPCONFIGPATH=/peers/orderer/localMspConfig CORE_PEER_LOCALMSPID="OrdererMSP" peer channel create -o orderer0:7050 -c default -f /peers/orderer/channel.tx
#
# CORE_PEER_MSPCONFIGPATH=/peers/producerPeer/localMspConfig CORE_PEER_ADDRESS=producer-peer:7051 CORE_PEER_LOCALMSPID=ProducerOrgMSP peer channel join -b default.block
#
# CORE_PEER_MSPCONFIGPATH=/peers/dealerPeer/localMspConfig CORE_PEER_ADDRESS=dealer-peer:7051 CORE_PEER_LOCALMSPID=DealerOrgMSP peer channel join -b default.block
#
# CORE_PEER_MSPCONFIGPATH=/peers/consumerPeer/localMspConfig CORE_PEER_ADDRESS=consumer-peer:7051 CORE_PEER_LOCALMSPID=ConsumerOrgMSP peer channel join -b default.block
