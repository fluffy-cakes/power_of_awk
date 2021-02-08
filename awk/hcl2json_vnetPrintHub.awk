/vnetName/ {
    gsub("\"", "")
    gsub(",", "")
    printf("VNET:\t%s\n", $2)
}
/vnetCidr/ {
    gsub("\"", "")
    gsub(",", "")
    printf("CIDR:\t%s\n\n", $2)
}

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