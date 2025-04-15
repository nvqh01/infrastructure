#!/bin/bash

START_COMMAND="start"
STOP_COMMAND="stop"

execute() {
    service=$1
    command=$2

    if ! [ -d "$service" ]; then
        echo "Service \"$service\" is not existed."
        return
    fi

    cd "./$service" 

    if ! [ -f "docker-compose.yaml" ] && ! [ -f "docker-compose.yml" ]; then
        echo "There is no file docker-compose.{yaml|yml} in service \"$service\"."
        return
    fi

    if [ "$command" == "$START_COMMAND" ]; then
        echo "Ready to intialize \"$service\"." 
        docker-compose --env-file ../.env up -d
    elif [ "$command" == "$STOP_COMMAND" ]; then
        echo "Ready to stop \"$service\"." 
        docker-compose --env-file ../.env down
    fi

    cd - > /dev/null 2>&1
}

main() {
    command=$1
    services=()

    if ! [ "$command" == "$START_COMMAND" ] && ! [ "$command" == "$STOP_COMMAND" ]; then
        echo "Please read file README.md to know how to run."
        return
    fi

    if [ "$2" == "all" ]; then
        services=$(ls -d */ | sed 's/\/ *$//')
    else
        services=${@:2}
    fi

    for service in $services; do
        execute "$service" "$command"
    done
}

main "$@"