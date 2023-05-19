#!/usr/bin/env bash

set -e -o pipefail

function displayIntro() {
    echo ""
    info "🔒 AWS ECS SSH"
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

function displayAccountId() {
    account=`aws sts get-caller-identity | jq -r .Account`
    success "Account: $account"
    echo ""
}

function askCluster() {
    echo "Select a cluster"
    cluster=`aws ecs list-clusters | jq -r '.clusterArns|sort[]|sub("(.*)cluster/";"")' | fzy --prompt "> "`
}

function askService() {
    echo "Select a service"
    service=`aws ecs list-services --cluster $cluster | jq -r ".serviceArns|sort[]|sub(\"(.*)$cluster/\";\"\")" | fzy --prompt "> "`
}

function enableExecuteCommand() {
    aws ecs update-service --cluster $cluster --service $service --enable-execute-command &> /dev/null
}

function askTask() {
    echo "Select a task"
    task=`aws ecs list-tasks --cluster $cluster --service $service | jq -r ".taskArns|sort[]|sub(\"(.*)$cluster/\";\"\")" | fzy --prompt "> "`
}

function askContainer() {
    echo "Select a container"
    container=`aws ecs describe-tasks --cluster $cluster --tasks $task | jq -r '.tasks[].containers[].name' | fzy --prompt "> "`
}

function displayConnectionDetails() {
    echo ""
    success "Cluster:   $cluster"
    success "Service:   $service"
    success "Task:      $task"
    success "Container: $container"
}

function connect() {
    aws ecs execute-command --cluster $cluster --container $container --task $task --interactive --command /bin/sh
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
    checkAuthenticated
    displayAccountId
    askCluster
    askService
    enableExecuteCommand
    askTask
    askContainer
    displayConnectionDetails
    connect
}

main
