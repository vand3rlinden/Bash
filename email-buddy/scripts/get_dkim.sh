#!/bin/bash
# Function to retrieve DKIM record for a domain
get_dkim_record() {
    domain="$1"
    selector="$2"
    dkim_record=$(dig "$selector._domainkey.$domain" TXT +short)
    if [ -n "$dkim_record" ]; then
        echo -e "\033[32mDKIM record for $selector._domainkey.$domain:\033[0m"
        echo "$dkim_record"
    else
        echo -e "\033[32mNo DKIM record found for $selector._domainkey.$domain\033[0m"
    fi
}

# Main script
if [ $# -lt 1 ]; then
    echo "Usage: $0 <domain> [selector]"
    exit 1
fi
    domain="$1"

# Prompt user for a DKIM selector if not provided
if [ -z "$2" ]; then
    echo -e "\033[32mPlease enter the DKIM selector (e.g., selector1, selector2):\033[0m"
    read -r selector
else
    selector="$2"
fi

get_dkim_record "$domain" "$selector"