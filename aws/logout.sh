#!/usr/bin/env bash

set -e -o pipefail

function displayIntro() {
    echo ""
    info "🔒 AWS Logout | Console + CLI"
    echo ""
}

function checkDependencies() {
    dependencies=("aws" "aws-vault")
    for command in "${dependencies[@]}"
    do
        if ! command -v $command &> /dev/null
        then
            error "You need to make sure $command is installed and available on your system."
            exit
        fi
    done
}

function logout() {
    aws sso logout
    aws-vault clear
    open "https://signin.aws.amazon.com/oauth?Action=logout&redirect_uri=https://aws.amazon.com"
    echo ""
    success "+ Logout successful"
}

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

function main() {
    displayIntro
    logout
}

main
