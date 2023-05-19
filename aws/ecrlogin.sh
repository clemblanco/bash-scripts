#!/usr/bin/env bash

set -e -o pipefail

# Imports
source $(dirname $0)/../lib/check_dependencies.sh
source $(dirname $0)/../lib/output.sh

function displayIntro() {
    echo ""
    info "🔒 AWS ECR Docker Login"
    echo ""
}

function checkDependencies() {
    dependencies=("aws" "fzy")
    for command in "${dependencies[@]}"
    do
        if ! command -v $command &> /dev/null
        then
            error "You need to make sure $command is installed and available on your system."
            exit
        fi
    done
}

function checkAuthenticated() {
    if ! aws sts get-caller-identity &> /dev/null
    then
        error "You don't seem to be authenticated with the aws CLI."
        exit
    fi
}

function askProfile() {
    echo "Select a profile"
    profile=`aws configure list-profiles | fzy --prompt "> "`
}

function connect() {
    echo ""
    account=`aws configure get sso_account_id --profile $profile`
    region=`aws configure get region --profile $profile`
    aws ecr get-login-password --profile $profile --region $region | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com
}

function main() {
    displayIntro
    checkDependencies
    checkAuthenticated
    askProfile
    connect
}

main
