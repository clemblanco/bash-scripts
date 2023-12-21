#!/usr/bin/env bash

set -e -o pipefail

# Imports
source $(dirname $0)/../lib/check_dependencies.sh
source $(dirname $0)/../lib/output.sh

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
    success "+ Login successful"
    echo "[$profile] AWS profile"
}

function main() {
    displayIntro
    checkDependencies
    askProfile
    login
}

main
