#!/bin/bash
###################################################################################################
# Project:        Aviaone.com | Automatic unjail and restart                                    ###
# Version:        1.0.0                                                                         ###
# Script Name:    Automatic unjail and restart                                                  ###
# Author:         Caesar Cipher-Regex | AviaOne.com                                             ###
# Author URI:     https://AviaOne.com                                                           ###
# Description:    Active monitoring to restart automatically the node when something is wrong.  ###
#                 This script can be used with the nodes built with Cosmos and Tendermint.       ###
# Version:        1.0.0                                                                         ###
# License:        GNU General Public License v3 or later                                        ###
# License URI:    http://www.gnu.org/licenses/gpl-3.0.html                                      ###
###################################################################################################
# Binary name
BINARY=celestia-appd
# Your wallet address here
WALLET=celestia1qycj0ymu9fqvwgyw4xz93p3n4a83jjk74ygh53
# Your node RPC address
NODE_RPC="http://127.0.0.1:26657"
# Trusted node RPC address, exemple "https://rpc.cosmos.network:26657"
SIDE_RPC="https://rpc-mamaki.pops.one/status?"
# File name to save you logs
LOG_FILE="/root/scripts/Log_Automatic_unjail_and_restart.log"
#
touch $LOG_FILE
REAL_BLOCK=$(curl -s "$SIDE_RPC/status" | jq '.result.sync_info.latest_block_height' | xargs )
STATUS=$(curl -s "$NODE_RPC/status")
CATCHING_UP=$(echo $STATUS | jq '.result.sync_info.catching_up')
LATEST_BLOCK=$(echo $STATUS | jq '.result.sync_info.latest_block_height' | xargs )
ADDRESS=$(echo $STATUS | jq '.result.validator_info.address' | xargs )
source $LOG_FILE
# to make a test activate the value below !
#REAL_BLOCK=350000
#LATEST_BLOCK=350000
#VOTING_POWER=0
#
# Writing in Log_Automatic_unjail_and_restart.log
echo 'LAST_BLOCK="'"$LATEST_BLOCK"'"' > $LOG_FILE
echo 'LAST_POWER="'"$VOTING_POWER"'"' >> $LOG_FILE
#
# Node stopped or node stuck in one block
curl -s "$NODE_RPC/status"> /dev/null
if [[ $? -ne 0 ]]; then
	echo | sudo systemctl restart $BINARY
		sleep 15s
elif [[ $LAST_BLOCK -ge $LATEST_BLOCK ]]; then
	echo | sudo systemctl restart $BINARY
		sleep 15s
fi
# Voting power ZERO
VOTING_POWER=$(echo $STATUS | jq '.result.validator_info.voting_power' | xargs )
if [[ $VOTING_POWER -lt 1 ]]; then
	echo | $BINARY tx slashing unjail --from $WALLET -y
		sleep 15s
fi
#
# This is can create a lot of restarting ! test it before to use.
#if [[ $CATCHING_UP = "true" ]]; then
#    echo | sudo systemctl restart $BINARY
#
#sleep 15s
#fi
#
#
#ONLY FOR TEST this script !
# Voting power 10000000
#if [[ $VOTING_POWER -lt 10000000 ]]; then
#	echo | $BINARY q bank balances $WALLET
#		sleep 15s
#fi
