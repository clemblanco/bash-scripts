#!/usr/bin/env bash

set -e -o pipefail

# Imports
source $(dirname $0)/../lib/check_dependencies.sh
source $(dirname $0)/../lib/output.sh

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

function main() {
    displayIntro
    logout
}

main
