#!/bin/bash

# Function to retrieve SPF record for a domain
get_spf_record() {
    domain="$1"
    spf_record=$(dig "$domain" TXT +short | grep -E 'v=spf1')
    if [ -n "$spf_record" ]; then
        echo -e "\033[32mSPF record for $domain:\033[0m"
        echo -e "$spf_record"
    else
        echo -e "\033[32mNo SPF record found for $domain\033[0m"
    fi
}

# Function to retrieve DMARC record for a domain
get_dmarc_record() {
    domain="$1"
    dmarc_record=$(dig "_dmarc.$domain" TXT +short)
    if [ -n "$dmarc_record" ]; then
        echo -e "\033[32mDMARC record for $domain:\033[0m"
        echo -e "$dmarc_record"
    else
        echo -e "\033[32mNo DMARC record found for $domain\033[0m"
    fi
}

# Function to retrieve DKIM record for a domain (selectors for Microsoft 365)
get_dkim_record() {
    domain="$1"
    selectors=("selector1" "selector2")
    for selector in "${selectors[@]}"; do
        dkim_record=$(dig "$selector._domainkey.$domain" TXT +short)
        if [ -n "$dkim_record" ]; then
            echo -e "\033[32mDKIM record for $selector.$domain:\033[0m"
            echo -e "$dkim_record"
        else
            echo -e "\033[32mNo DKIM record found for $selector.$domain\033[0m"
        fi
    done
}

# Main script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain="$1"
get_spf_record "$domain"
get_dmarc_record "$domain"
get_dkim_record "$domain"
