# The Power of AWK

This is a collection of AWK scripts that I have built to help aid productivity on some projects. Although AWK is a powerful programming language, it is still limited to the abilities of searching text (line by line) and the structure on which it is written. Please bear in mind that the majority of these scripts rely on this, and it will vary for each client/project/file.

## Terraform Provider Output Script

The `provider.sh` script will search all the subfolders for the provider versions in their nested block and print out results depending upon how the script is called.

This script is largely based on the Terraform structure below:

```hcl
terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<=1.40"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
```

Knowing that my code structure is based on two spaces as indent, the following code has been written for this. In the following AWK block, I am looking for a provider type listed in the `required_providers` block, where it starts `{` and where it ends `}` To search between blocks with AWK we put a comma between the regex search patterns: `/pattern1/,/pattern2/` . Here I use `/^[[:space:]]{2,2}required_providers/,/^[[:space:]]{2,2}}$/`, which looking for `required_providers {`.

Note that I have used specific spacing to determine the start and end blocks; because AWK doesn't read Terraform language syntax, it can only read text line by line. If I didn't do this, the end block could be any of the iterations of `}` after the search field of `required_providers`, although it usually picks the very last one on the page.

Using nested conditions I can then perform a line by line search between that block where the first iteration I'm searching for is: a word, followed by a space, an equals sign, another space, and finally an opening curly braces. Which essentially means that I'm searching for something like: `azuread = {`, or `azurerm = {`. Once I have found that pattern, I assign the word to a variable called `pr` and move to the next search field.

The next field works on the same premises, where I'm searching for the `versions` of that nested block, such as `version = "<=1.40"`. I am then able to use the `printf` function to bring those values together on the same line, passing in the variable and the recently found version value. Please note the use of `gsub` where I remove all inverted commas for pretty printing.

```awk
/^[[:space:]]{2,2}required_providers/,/^[[:space:]]{2,2}}$/ {
    gsub("\"", "")
    if ($0 ~ /[[:alpha:]][[:space:]]=[[:space:]]\{/) {
        pr = $1
    }
    if ($0 ~ /version[[:space:]]=[[:space:]]/) {
        printf("%s %s\n", pr, $3)
    }
}
```

All this can now be utilised as part of script, passing in arguments to print out the required outputs:

### Details

`./provider.sh details`

When running the script with the argument details it will print out a list of types of providers found in each folder:

```bash
\appdynamicsagent contains:
azurerm <=1.40

\artifactory_base contains:
azurerm =2.46.1

\artifactory_base_roles contains:
azurerm 2.2

\azdo_agent_scaleset contains:
azurerm <=2.43
random 3.0.0
null 3.0.0

\azfw_rules contains:
azurerm =1.42
...
```

### All

`./provider.sh all`

If you want to just print out a list of the providers and their versions, but not the directory name, use:

```bash
azurerm <=1.40
azurerm =2.46.1
azurerm 2.2
azurerm <=2.43
random 3.0.0
null 3.0.0
azurerm =1.42
azurerm 2.2
azurerm =2.44.0
azurerm >2.0.0
azurerm 2.15
azurerm 2.15
azurerm <=1.40
azurerm >=2.40.0
...
```

### Uniq

`./provider.sh uniq`

With the `uniq` argument it will print out all the providers with their versions, as well as the collective number of times they are used throughout the subfolders:

```bash
      1 azuread =0.8
      3 azurerm 2.15
      7 azurerm 2.2
      2 azurerm 2.40.0
      4 azurerm <=1.40
      1 azurerm <=2.43
      1 azurerm =1.38.0
      1 azurerm =1.42
      1 azurerm =2.30.0
      1 azurerm =2.33
      1 azurerm =2.34.0
      1 azurerm >=2.40.0
      2 azurerm ~>2.38.0
      2 external 1.2.0
      1 luminate 1.0.8
      1 null 3.0.0
      1 panos 1.6.2
      3 panos 1.6.3
      1 random 3.0.0
```

### Types

`provider.sh types`

Finally this will print out the types of resource providers used, on the basis that the provider written before the type of resource deployed:

```hcl
# Example type of item lookup
resource "azurerm_resource_group" "luminaterg" {
  name     = "${module.names.standard["resource-group"]}-luminate-connector"
  location = var.ARM_LOCATION
  tags = var.global_settings.tags
}
```

An output example:

```bash
azuread
azurerm
local
luminate
null
panos
random
```

## Markdown Generator

On a clients project we used Terraform `.tfvars` files to help build out the hub and spoke environment under the organisational structure of the inhouse project names, and the region where they are deployed, resulting in files called `networking_hub.tfvars` or `networking_spoke.tfvars`. There were quite a number  projects, which resulted in a lot of Org sub folders. In order to easily identify the networking structure of each client at a glance (their virtual network name/CIDR, and the subnet names/CIDRs), I developed a Markdown file generator that automatically ran whenever anyone pushed a PR that touched these subfolders. It would initiate the repo being downloaded, a new Markdown file generated, and then compares the new file with the old; if there are any changes to the file, a PR will automatically be raised by a PR Bot.

I have scripted two ways to do this; the first is with pure AWK functionality that depends upon the code structure of the file, whereas the second is using a third party application (https://github.com/tmccombs/hcl2json) that converts the `.tfvars` to JSON, performs a JQ query on selected objects, and then uses AWK to print the results. By far the best way to perform this is to use the `hcl2json` tool; because it uses JSON to parse the object, there's less chances of things going wrong using an AWK script (bad indentation and whatnot). Take note that introducing a third party tool can add some security concerns which could require compliance to sign off on using it. I won't go into the full details outlining each line of the scripts I've posted, I'll leave that up to your technological knowhow and understanding to decipher them, however here's a selected comparison in code using pure AWK abilities vs HCL2JSON with AWK.

```awk
# pure AWK of 'special subnets'
/^[[:space:]]*specialsubnets/,/^[[:space:]]*subnets/ {
    gsub("\"", "")
    if ($1 ~ "name") {
        printf("%-20s", $3)
    }
    if ($1 ~ "cidr") {
        printf("\t%10s\n", $3)
    }
}

# vs HCL2JSON with AWK
/name/ {
    gsub("\"", "")
    gsub(",", "")
    printf("%-20s\t", $2)
}
/cidr/ {
    gsub("\"", "")
    gsub(",", "")
    printf("%s\n", $2)
}
```

The creation of the Markdown using Bash scripting is essentially the same between the two, with the only difference how each `.tfvars` file is being processed. Please see [Pure AWK](awk_markdown.sh) vs [HCL2JSON with AWK](hcl2json_markdown.sh) for exact reference. However I will point out the use of Bash scripting to help build out the Markdown wrapper of each processing.

```bash
#!/bin/bash

while IFS= read -r -d '' file
do
	# In this section I am using the path of the org folder structure to build out the titles, splitting the paths by "/" and selecting those which I need
    header="$(cut -d/ -f3 <<<"${file}")"
    headerLoc="$(cut -d/ -f4 <<<"${file}")"
    location="${file//..\//}"

	# I then use Printf to help build out the required Markdown code for the titles and file block
    printf '### %s in %s' "${header}" "${headerLoc}"
    printf '\n`~ %s\n' "${location}:\`"
    printf "\`\`\`\n"						# Starting the ``` code block

    # Pure AWK or HCL2JSON processing is here (deleted; see links above)

	printf "\`\`\`\n\n"						# Ending the ``` code block
done < <(find ./org -type f -name 'networking_hub*' -print0) > ./org/README.md
# ^^ In the above line we find all .tfvars files, pass them in as a list, iterate on each generating a Markdown file, output/append all the results to README.md

# Once the original README file has been generated we use AWK again to filter Markdown titles of # to create a hyperlink shortcut list
# Create header
awk -f ./awk/awk_vnetPrintMenu.awk ./org/README.md > ./tmp

# # Join files together
tee -a ./tmp < ./org/README.md > /dev/null 2>&1

# # Final README creation
mv ./tmp ./README.md

cat ./README.md
```

For bonus points we can move this logic to an Azure DevOps pipeline, or another CI/CD tool for your choosing, but essentially it's just a Bash script wrapped up in some YAML You can view the whole file [here](markdown_pipeline.yml), but I will pick out a few things to note.

The essential part of only triggering once code is pushed into Master (line 9) and within the Org folder (line 12)

```yaml
File: markdown_pipeline.yml
6: trigger:
7:   branches:
8:     include:
9:     - master
10:   paths:
11:     include:
12:     - org/
```

At the start of the script we check out the repo via the command line, using a GitHub service account as the authenticator.

```bash
File: markdown_pipeline.yml
26:     BRANCH="prBot/autoPRvnets"
27:
28:     pwd
29:     ls -la
30:
31:     git clone https://SVC-ACCOUNT-NAME:$(GITPAT)@github.com/MY-ORGANISATIONAL-NAME/MY-REPO-NAME.git
32:     cd ./MY-REPO-NAME || exit 1
33:     pwd && ls -la
34:     git checkout master
35:     cd ./scripts/markdown/vnets || exit 1
```

*The execution of the Bash script mentioned above goes here; lines `38 to 78`*

Using general Bash scripting we compare the output of the Markdown file recently generated with the one already existing in the Org folder. If there are no changes, delete the file and end the script.

```bash
File: markdown_pipeline.yml
83:     file1="./org/README.md"
84:     file2="./README.md"
85:
86:
87:     if cmp -s "$file1" "$file2"; then
88:         printf 'The file "%s" is the same as "%s"\n' "$file1" "$file2"
89:         rm -f "$file2"
90:         exit 0
91:     else
92:         printf 'The file "%s" is different from "%s"\n' "$file1" "$file2"
93:         mv -f "$file2" "$file1"
```

If there are differences in the file; create a new branch, move the file into the branch and commit it.

```bash
File: markdown_pipeline.yml
96:         git config user.email "pr@bot.com"
97:         git config user.name "PR Bot"
98:         git checkout -b "$BRANCH"
99:         git push origin "$BRANCH"
100:         git add "$file1"
101:         git commit -m "Update markdown for client services"
102:         git push origin "$BRANCH"
```

Finally, raise a PR with basic comments using the GitHub API

```bash
File: markdown_pipeline.yml
105:         # Create PR
106:         curl --location --request POST 'https://api.github.com/repos/MY-ORGANISATIONAL-NAME/MY-REPO-NAME/pulls' \
107:             --header 'Accept: application/vnd.github.v3+json' \
108:             --header "Authorization: Bearer $(GITPAT)" \
109:             --header 'Content-Type: application/json' \
110:             -d @- << EOF
111:     {
112:         "head": "$BRANCH",
113:         "base": "master",
114:         "title": "#patch auto PR on VNET TFvars updates",
115:         "body": "### PR Bot\nSome changes have been made to VNET TFvars, updating markdown to replicate"
116:     }
117:     EOF
118:     fi
```

...don't forget to clear your Git credentials!

```bash
File: markdown_pipeline.yml
121:     echo "** Removing config **"
122:     git config --unset remote.origin.url
```

## Service Accounts End Dates

On a clients project we encountered an issue where our Service Accounts were coming up to a year old since creation, which usually means that they are going to expire (unless you set a custom date!). Unfortunately there's no easy way to determine the end dates of your App Registrations or Service Principals in Azure, so I conjured up the following script to help aid this. I would have preferred do to this in PowerShell, but due to its limitations I could not find a good way to spit out all the details I needed. You can find the full script [here](service_accounts.sh), but once again I'll only point out the important bits.

The first part is to use the Azure CLI and generate a list of all the SPs (or App Registrations; lines 10-15), and the pipe that into JQ for parsing. I found it easier to narrow down the outputs I want via JQ first and then pretty print in AWK later.

You can see here that on line 6 I use a regex pattern to match the name of the service principal. In this case our accounts start with `SP-` followed by any character repeated no less than 8 times, and no more than 8 times, followed by a hyphen and any character repeated any amount of times. Essentially I'm looking for something that looks like `SP-12345678-asdf`. This is the key part to help list our SPs, so unless you have some good regex patterns to you use, and/or your naming convention for service accounts is all over the place, you might find this somewhat hard to re-use.

Using JQ we can filter the outputs in two ways; those without passwords set, where `passwordCredentials` array is empty;`[]`, and those with something inside the array, which is usually a block of code that contains a string for `endDate`. Thus we can build a JSON output that would contain `null` for no password, or the actual date for when it ends.

```bash
File: service_accounts.sh
3: az ad sp list --all \
4:     | jq '[ .[]
5:         | select(.appDisplayName != null)
6:         | select(.appDisplayName | match("^SP-.{8,8}-.*"))
7:         | if .passwordCredentials == [] then {name: .appDisplayName, creds: {spn: "null"}}
8:             else {name: .appDisplayName, creds: {spn: .passwordCredentials[].endDate}} end ]' > spn.json
```

Where the resulting JSON would look something like:

```json
    {
        "name": "SP-87654321-deployment",
        "creds": {
            "spn": "null"
        }
    },
    {
        "name": "SP-12345678-654321-cust",
        "creds": {
            "spn": "2021-12-18T09:43:18+00:00"
        }
    }
```

Once both Service Account and App Registration JSON files are generated we can merge them together. Seeing as though our App Registrations are usually named similar to the Service Principals, I can mash them together to make one file which I can parse with an AWK command.

The resulting mashing of line 19 from below, would look something like:

```json
    {
        "name": "SP-87654321-deployment",
        "creds": {
            "app": "2021-12-18T09:43:18+00:00",
            "spn": "null"
        }
    },
    {
        "name": "SP-12345678-654321-cust",
        "creds": {
            "app": "null",
            "spn": "2021-12-18T09:43:18+00:00"
        }
    }
```

I would be lying if I said I fully understand that JQ command on line 19, so I'll leave it up to you to do any research on it if you want to. However, now that we have both files together we can use AWK to parse them out into pretty text using `printf` function.

```bash
File: service_accounts.sh
19: jq -s 'flatten | group_by(.name) | map(reduce .[] as $x ({}; . * $x)) | sort_by(.name)' app.json spn.json \
20:     | awk '
21:         /name/ {
22:             gsub("\"", "")
23:             gsub(",", "")
24:             printf("%-30s", $2)
25:         }
26:         /app/ {
27:             gsub("\"", "")
28:             gsub(",", "")
29:             printf("\tapp: %-32s", $2)
30:         }
31:         /spn/ {
32:             gsub("\"", "")
33:             gsub(",", "")
34:             printf("\tspn: %-32s\n", $2)
35:         }'
```

Which would finally result in the following output:

```bash
SP-87654321-deployment          app: 2021-12-18T09:43:18+00:00      spn: null
SP-12345678-654321-cust         app: null                           spn: 021-12-18T09:43:18+00:00
```

For bonus points again you can output the accounts which are ending within the next seven days by getting todays date, adding 7 days, and filtering those that dates are less than the value

```bash
File: service_accounts.sh
41: OS=$(uname -s)
42: if   [[ "$OS" == "Linux" ]]; then
43:     CURRENT_TIME=$(date -u +'%Y-%m-%dT%H:%M:%S' -d "+7 days") # Linux
44: 
45: elif [[ "$OS" == "Darwin" ]]; then
46:     CURRENT_TIME=$(date -u -v +7d +'%Y-%m-%dT%H:%M:%S') # Mac
47: 
48: else
49:     echo "...is this a Linux box??"
50:     exit 1
51: fi
52: 
53: 
54: jq ".[] | select(.creds.app < \"$CURRENT_TIME\")" app.json > end_app.json
55: jq ".[] | select(.creds.spn < \"$CURRENT_TIME\")" spn.json > end_spn.json
```

Where once again you mash the two JSON files together and print out only those of concern:

```bash
File: service_accounts.sh
59: jq -s 'flatten | group_by(.name) | map(reduce .[] as $x ({}; . * $x)) | sort_by(.name)' end_app.json end_spn.json \
60:     | awk '
61:         /name/ {
62:             gsub("\"", "")
63:             gsub(",", "")
64:             printf("%-30s\n", $2)
65:         }
66:         /app/ {
67:             gsub("\"", "")
68:             gsub(",", "")
69:             printf("\tapp: %-32s\n", $2)
70:         }
71:         /spn/ {
72:             gsub("\"", "")
73:             gsub(",", "")
74:             printf("\tspn: %-32s\n\n", $2)
75:         }'
```

