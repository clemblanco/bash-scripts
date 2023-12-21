#!/usr/bin/env bash

set -e -o pipefail

# Imports
source $(dirname $0)/../lib/check_dependencies.sh
source $(dirname $0)/../lib/output.sh

function displayIntro() {
    echo ""
    info "🔒 AWS Login | Chrome Profile"
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

function login {
    # set to yes to create one-time use profiles in /tmp
    # anything else will create them in $HOME/.aws/chrome
    TEMP_PROFILE="yes"

    # set to yes to always start in a new window
    NEW_WINDOW="yes"

    if [[ -z "$profile" ]]; then
        echo "Profile is a required argument" >&2
        return 1
    fi

    # replace non word and not - with __
    profile_dir_name=${profile//[^a-zA-Z0-9_-]/__}
    user_data_dir="${HOME}/.aws/chrome/${profile_dir_name}"
    new_window_arg=''

    if [[ "$TEMP_PROFILE" = "yes" ]]; then
        user_data_dir=$(mktemp -d /tmp/aws_chrome_userdata.XXXXXXXX)
    fi

    if [[ "$NEW_WINDOW" = "yes" ]]; then
        new_window_arg='--new-window'
    fi

    # run aws-vault
    # --prompt osascript only works on OSX
    url=$(aws-vault login $profile --stdout --prompt osascript)
    status=$?

    if [[ ${status} -ne 0 ]]; then
        # bash will also capture stderr, so echo $url
        echo ${url}
        return ${status}
    fi

    mkdir -p ${user_data_dir}
    disk_cache_dir=$(mktemp -d /tmp/aws_chrome_cache.XXXXXXXX)
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --no-first-run \
        --user-data-dir=${user_data_dir} \
        --disk-cache-dir=${disk_cache_dir} \
        ${new_window_arg} \
        ${url} \
      >/dev/null 2>&1 &

    echo ""
    success "+ Login successful"
    echo "[$profile] AWS profile with a dedicated Chrome profile"
}

function main() {
    displayIntro
    checkDependencies
    askProfile
    login
}

main
