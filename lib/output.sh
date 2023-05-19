#!/bin/bash

function info() {
    message=$1
    YELLOW='\033[0;33m'
    NC='\033[0m'

    multiline "${YELLOW}${message}${NC}"
}

function success() {
    message=$1
    GREEN='\033[0;32m'
    NC='\033[0m'

    multiline "${GREEN}${message}${NC}"
}

function error() {
    message=$1
    RED='\033[0;31m'
    NC='\033[0m'

    multiline "${RED}${message}${NC}"
}

function multiline() {
    string=$1

    if [[ :$SHELLOPTS: == *:posix:* ]]; then
         echo "$string"
     else
         echo -e "$string"
     fi
}
