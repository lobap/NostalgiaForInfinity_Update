#!/bin/bash

ROOT_PATH="/opt"
NFI_PATH="${ROOT_PATH}/NostalgiaForInfinity/NostalgiaForInfinityNext.py"
FT_PATH="${ROOT_PATH}/freqtrade/user_data/strategies/NostalgiaForInfinityNext.py"
TG_TOKEN=""
TG_CHAT_ID=""

cd $(dirname ${NFI_PATH})

GITRESPONSE=`git pull`
UPDATED='Already up to date.'

if [[ $GITRESPONSE != $UPDATED ]]; then
        cp NostalgiaForInfinityNext.py ${FT_PATH}

        curl -s --data "text=New NFI commit! Please wait for reload..." \
                --data "parse_mode=markdown" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"

        sleep 120

        cd $(dirname ${FT_PATH})
        docker-compose down > /dev/null &&
        docker-compose build --pull > /dev/null &&
        docker-compose up -d --remove-orphans > /dev/null &&
        docker system prune --volumes -af > /dev/null

        curl -s --data "text=NFI reload has been completed!" \
                --data "parse_mode=markdown" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
fi