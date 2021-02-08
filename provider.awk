/^[[:space:]]{2,2}required_providers/,/^[[:space:]]{2,2}}$/ {
    gsub("\"", "")
    if ($0 ~ /[[:alpha:]][[:space:]]=[[:space:]]\{/) {
        pr = $1
    }
    if ($0 ~ /version[[:space:]]=[[:space:]]/) {
        printf("%s %s\n", pr, $3)
    }
}
