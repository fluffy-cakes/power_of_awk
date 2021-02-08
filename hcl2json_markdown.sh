#!/bin/bash

find . -type f -name 'README.md' -exec rm -f {} +

# VNET HUB
while IFS= read -r -d '' file
do
    header="$(cut -d/ -f3 <<<"${file}")"
    headerLoc="$(cut -d/ -f4 <<<"${file}")"
    location="${file//..\//}"

    printf '### %s in %s' "${header}" "${headerLoc}"
    printf '\n`~ %s\n' "${location}:\`"
    printf "\`\`\`\n"

    hcl2json "$file" \
        | jq '.vnet_transit_object
            | select(.vnet)
            | {vnetName: .vnet.name, vnetCidr: .vnet.address_space[0]}' \
        | awk -f ./awk/hcl2json_vnetPrintHub.awk

    hcl2json "$file" \
        | jq '.vnet_transit_object.specialsubnets
            | to_entries
            | map(.value | { name, cidr })' \
        | awk -f ./awk/hcl2json_vnetPrintHub.awk

    hcl2json "$file" \
        | jq '.vnet_transit_object.subnets
            | to_entries
            | map(.value | { name, cidr })' \
        | awk -f ./awk/hcl2json_vnetPrintHub.awk

    printf "\n\n"

    hcl2json "$file" \
        | jq '.vnet_shared_services_object
            | select(.vnet)
            | {vnetName: .vnet.name, vnetCidr: .vnet.address_space[0]}' \
        | awk -f ./awk/hcl2json_vnetPrintHub.awk

    hcl2json "$file" \
        | jq '.vnet_shared_services_object.subnets
            | to_entries
            | map(.value | { name, cidr })' \
        | awk -f ./awk/hcl2json_vnetPrintHub.awk

    printf "\`\`\`\n\n"
done < <(find . -type f -name 'networking_hub*' -print0 | sort -z) > ./README.md


# VNET SPOKES
while IFS= read -r -d '' file
do
    header="$(cut -d/ -f3 <<<"${file}")"
    headerLoc="$(cut -d/ -f4 <<<"${file}")"
    location="${file//..\//}"

    printf '### %s in %s' "${header}" "${headerLoc}"
    printf '\n`~ %s\n' "${location}:\`"
    printf "\`\`\`\n"

    hcl2json "$file" \
        | jq '.[]
            | select(.vnet)
            | {vnetName: .vnet.name, vnetCidr: .vnet.address_space[0]}' \
        | awk -f ./awk/hcl2json_vnetPrintSpoke.awk

    hcl2json "$file" \
        | jq '.vnet_spoke_object.subnets
            | to_entries
            | map(.value | { name, cidr })' \
        | awk -f ./awk/hcl2json_vnetPrintSpoke.awk

    printf "\`\`\`\n\n"
done < <(find . -type f -name 'networking_spoke*' -print0 | sort -z) >> ./README.md

# Create header
awk -f ./awk/hcl2json_vnetPrintMenu.awk ./README.md > ./tmp

# # Join files together
tee -a ./tmp < ./README.md > /dev/null 2>&1

# # Final README creation
mv ./tmp ./README.md

cat ./README.md