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
        sleep 120

        GITCOMMITTER=`git show -s --format='%cn'`
        GITVERSION=`git show -s --format='%h'`
        GITCOMMENT=`git show -s --format='%s'`
        
        cp NostalgiaForInfinityNext.py ${FT_PATH}
        curl -s --data "text=🆕 <b>New <i>NostalgiaForInfinity</i> version</b> by <code>${GITCOMMITTER}</code>!%0ACommit: <code>$GITVERSION</code>%0AComment: <code>${GITCOMMENT}</code>%0A⏳ Please wait for reload..." \
                --data "parse_mode=HTML" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"

        cd $(dirname ${FT_PATH})
        /usr/local/bin/docker-compose down > /dev/null &&
        /usr/local/bin/docker-compose build --pull > /dev/null &&
        /usr/local/bin/docker-compose up -d --remove-orphans > /dev/null &&
        docker system prune --volumes -af > /dev/null &&
        sleep 20 &&
        curl -s --data "text=🆗 NFI reload has been completed!" \
                --data "parse_mode=HTML" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
fi