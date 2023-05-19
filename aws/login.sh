#!/usr/bin/env bash

set -e -o pipefail

function displayIntro() {
    echo ""
    info "🔒 AWS Login | Console + CLI"
    echo ""
}

function checkDependencies() {
    dependencies=("aws" "aws-vault" "fzy")
    for command in "${dependencies[@]}"
    do
        if ! command -v $command &> /dev/null
        then
            error "You need to make sure $command is installed and available on your system."
            exit
        fi
    done
}

function askProfile() {
    echo "Select a profile"
    profile=`aws configure list-profiles | fzy --prompt "> "`
}

function login() {
  echo ""
  info "-- AWS Console"
  aws-vault login $profile
  echo ""
  info "-- AWS CLI"
  aws sso login --profile $profile
  echo ""
  success "+ Login successful - \"$profile\" profile"
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
    checkDependencies
    askProfile
    login
}

main
