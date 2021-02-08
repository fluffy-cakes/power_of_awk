#!/bin/bash

az ad sp list --all \
    | jq '[ .[]
        | select(.appDisplayName != null)
        | select(.appDisplayName | match("^SP-.{8,8}-.*"))
        | if .passwordCredentials == [] then {name: .appDisplayName, creds: {spn: "null"}}
            else {name: .appDisplayName, creds: {spn: .passwordCredentials[].endDate}} end ]' > spn.json

az ad app list --all \
    | jq '[ .[]
        | select(.displayName != null)
        | select(.displayName | match("^SP-.{8,8}-.*"))
        | if .passwordCredentials == [] then {name: .displayName, creds: {app: "null"}}
            else {name: .displayName, creds: {app: .passwordCredentials[].endDate}} end ]' > app.json

printf "\n All Service Accounts\n ####################\n\n"

jq -s 'flatten | group_by(.name) | map(reduce .[] as $x ({}; . * $x)) | sort_by(.name)' app.json spn.json \
    | awk '
        /name/ {
            gsub("\"", "")
            gsub(",", "")
            printf("%-30s", $2)
        }
        /app/ {
            gsub("\"", "")
            gsub(",", "")
            printf("\tapp: %-32s", $2)
        }
        /spn/ {
            gsub("\"", "")
            gsub(",", "")
            printf("\tspn: %-32s\n", $2)
        }'



# Get creds ending within 7 days

OS=$(uname -s)
if   [[ "$OS" == "Linux" ]]; then
    CURRENT_TIME=$(date -u +'%Y-%m-%dT%H:%M:%S' -d "+7 days") # Linux

elif [[ "$OS" == "Darwin" ]]; then
    CURRENT_TIME=$(date -u -v +7d +'%Y-%m-%dT%H:%M:%S') # Mac

else
    echo "...is this a Linux box??"
    exit 1
fi


jq ".[] | select(.creds.app < \"$CURRENT_TIME\")" app.json > end_app.json
jq ".[] | select(.creds.spn < \"$CURRENT_TIME\")" spn.json > end_spn.json

printf "\n Service Accounts Ending Within 7 Days\n #####################################\n\n"

jq -s 'flatten | group_by(.name) | map(reduce .[] as $x ({}; . * $x)) | sort_by(.name)' end_app.json end_spn.json \
    | awk '
        /name/ {
            gsub("\"", "")
            gsub(",", "")
            printf("%-30s\n", $2)
        }
        /app/ {
            gsub("\"", "")
            gsub(",", "")
            printf("\tapp: %-32s\n", $2)
        }
        /spn/ {
            gsub("\"", "")
            gsub(",", "")
            printf("\tspn: %-32s\n\n", $2)
        }'

printf "\n Commands To Filter By Name\n ##########################\n\n"

printf "
az ad app list --all \\
    | jq '.[]
        | select(.displayName != null)
        | select(.displayName | match(\"..insert APP name here..\"))'

Use the ID located in the JSON array called \"appId\" to update the APP\n\n"

printf "
az ad sp list --all \\
    | jq '.[]
        | select(.displayName != null)
        | select(.displayName | match(\"..insert SPN name here..\"))'

Use the ID located in the JSON array called \"servicePrincipalNames\" to update the SPN\n\n"


rm -f ./app.json ./spn.json
rm -f ./end_app.json ./end_spn.json
