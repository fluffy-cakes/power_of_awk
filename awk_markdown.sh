#!/bin/bash

find . -type f -name 'README.md' -exec rm -f {} +

while IFS= read -r -d '' file
do
    header="$(cut -d/ -f3 <<<"${file}")"
    headerLoc="$(cut -d/ -f4 <<<"${file}")"
    location="${file//..\//}"

    printf '### %s in %s' "${header}" "${headerLoc}"
    printf '\n`~ %s\n' "${location}:\`"
    printf "\`\`\`\n"

    awk -f ./awk/awk_vnetPrintHub.awk "$file"

    printf "\`\`\`\n\n"
done < <(find ./org -type f -name 'networking_hub*' -print0) > ./org/README.md

while IFS= read -r -d '' file
do
    header="$(cut -d/ -f3 <<<"${file}")"
    headerLoc="$(cut -d/ -f4 <<<"${file}")"
    location="${file//..\//}"

    printf '### %s in %s' "${header}" "${headerLoc}"
    printf '\n`~ %s\n' "${location}:\`"
    printf "\`\`\`\n"

    awk -f ./awk/awk_vnetPrintSpoke.awk "$file"

    printf "\`\`\`\n\n"
done < <(find ./org -type f -name 'networking_spoke*' -print0) >> ./org/README.md

# Create header
awk -f ./awk/awk_vnetPrintMenu.awk ./org/README.md > ./tmp

# # Join files together
tee -a ./tmp < ./org/README.md > /dev/null 2>&1

# # Final README creation
mv ./tmp ./README.md

cat ./README.md