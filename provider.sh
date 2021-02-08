#!/bin/bash

AWK="${PWD}/provider.awk"

TYPE=$1

function listDetails {
    for i in $(find . -name "*.tf" -execdir sh -c 'pwd' sh {} + | sort | uniq); do
        cd "$i" || exit
        printf '\n\\%s\n' "${PWD##*/} contains:"
        find . -maxdepth 1 -name "*.tf" -exec awk -f "$AWK" {} +
    done
}

function listUniq {
    find . -name "*.tf" -exec awk -f "$AWK" {} + | sort | uniq -c
}

function listAll {
    find . -name "*.tf" -exec awk -f "$AWK" {} +
}

function listTypes {
    find . -name "*.tf" -exec awk '/^resource[[:space:]]+"/ { gsub("\"",""); print $2 }' {} + | awk -F_ '{ print $1 }' | sort | uniq
}


if   [[ $TYPE == "details" ]]; then
    listDetails

elif [[ $TYPE == "uniq" ]]; then
    listUniq

elif [[ $TYPE == "all" ]]; then
    listAll

elif [[ $TYPE == "types" ]]; then
    listTypes
fi