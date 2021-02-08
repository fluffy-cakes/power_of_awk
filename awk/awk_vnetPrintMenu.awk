BEGIN {
    printf("# Environment VNET Info\n")
}
/#/ {
    gsub("#", "")
    gsub(" ", "-")
    string1 = (substr($0, 2))
    string2 = tolower(substr($0, 2))
    printf("- [%s](#%s)\n", string1, string2)
}
END {
    printf("\n\n")
}