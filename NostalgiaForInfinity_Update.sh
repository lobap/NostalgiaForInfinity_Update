#!/bin/bash

ROOT_PATH="/opt"
NFI_PATH="${ROOT_PATH}/NostalgiaForInfinity/NostalgiaForInfinityNext.py"
FT_PATH="${ROOT_PATH}/freqtrade/user_data/strategies/NostalgiaForInfinityNext.py"
TG_TOKEN=""
TG_CHAT_ID=""

# Go to NFI directory
cd $(dirname ${NFI_PATH})

GITRESPONSE=`git pull`
UPDATED='Already up to date.'

if [[ $GITRESPONSE != $UPDATED ]]; then
        cp NostalgiaForInfinityNext.py ${FT_PATH}

        curl -s --data "text=There is a new NFI commit. Please \`/reload_config\` to get it loaded." \
                --data "parse_mode=markdown" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
fi