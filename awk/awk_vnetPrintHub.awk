/vnet_transit_object/,/}/ {
    gsub("\"", "")
    if ($1 ~ "name") {
        printf("VNET:\t%s\n", $3)
    }
}

/vnet_shared_services_object/,/}/ {
    gsub("\"", "")
    if ($1 ~ "name") {
        printf("\n\nVNET:\t%s\n", $3)
    }
}

/address_space/ {
    gsub(/\[/, "")
    gsub(/\]/, "")
    gsub("\"", "")
    printf("CIDR:\t%s\n\n", $3)
}

/^[[:space:]]*specialsubnets/,/^[[:space:]]*subnets/ {
    gsub("\"", "")
    if ($1 ~ "name") {
        printf("%-20s", $3)
    }
    if ($1 ~ "cidr") {
        printf("\t%10s\n", $3)
    }
}

/^[[:space:]]*subnets/,/^[[:space:]]{4,4}}/ {
    gsub("\"", "")
    if (($1 ~ "name") && ($3 !~ "delegation")) {
        printf("%-20s", $3)
    }
    if ($1 ~ "cidr") {
        printf("\t%-10s\n", $3)
    }
}

