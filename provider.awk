/^[[:space:]]{2}required_providers/,/^[[:space:]]{2}}$/ {
    gsub("\"", "")
    if ($0 ~ /[[:alpha:]][[:space:]]=[[:space:]]\{/) {
        pr = $1
    }
    if ($0 ~ /version[[:space:]]*[<>=]+[[:space:]]*/) {
        ver = $0
        sub(/^[[:space:]]*version[[:space:]]*(=[[:space:]]*)?/, "", ver)
        print pr, ver
    }
}