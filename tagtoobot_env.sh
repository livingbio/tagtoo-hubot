#!/bin/bash

target=${TARGET:="local"}
declare -x CONFIGS

concat () {
    CONFIGS="$CONFIGS $1"
}

set_environ () {
    if [ "$target" = "local" ]
    then
        env $@ bin/hubot
    elif [ "$target" = "heroku" ]
    then
        heroku config:set $@
    fi
}

# hipchat
concat HUBOT_HIPCHAT_JID=71241_502945@chat.hipchat.com
concat HUBOT_HIPCHAT_PASSWORD=tagtoohubot
concat HUBOT_HIPCHAT_TOKEN=93623ed7ef4b8a32d6b19351481d8e

# trello
concat HUBOT_TRELLO_KEY=11f0537910cc6e6056ee6e87d99c2acf
concat HUBOT_TRELLO_LIST=xgeP23kS
concat HUBOT_TRELLO_TOKEN=1f2ae4c756fb84459226d7c014c5621c82622eba074b8fcdb77eef9d58b1c055

concat HUBOT_AUTH_ADMIN=true

set_environ $CONFIGS
