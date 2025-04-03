#!/bin/bash

# Function to retrieve SPF record for a domain
get_spf_record() {
    domain="$1"
    spf_record=$(dig "$domain" TXT +short | grep -E 'v=spf1')
    if [ -n "$spf_record" ]; then
        echo -e "\033[32mSPF record for $domain:\033[0m"
        echo "$spf_record"
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
        echo "$dmarc_record"

        # Check for DMARC policy
        if echo "$dmarc_record" | grep -q 'p=reject'; then
            echo -e "\033[32mDomain is DMARC compliant — the domain is protected against abuse.\033[0m"
        elif echo "$dmarc_record" | grep -q 'p=quarantine'; then
            echo -e "\033[33mDomain is partially DMARC compliant — the domain is somewhat protected against abuse.\033[0m"
        else
            echo -e "\033[31mDomain is not DMARC compliant — the domain is not protected against abuse.\033[0m"
        fi
    else
        echo -e "\033[31mNo DMARC record found for $domain\033[0m"
        echo -e "\033[31mDomain is not DMARC compliant — the domain is not protected against abuse.\033[0m"
    fi
}

# Main script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain="$1"
get_spf_record "$domain"
get_dmarc_record "$domain"

#You can run it by providing a domainname as an argument, like: `bash get_spfdmarc.sh example.com`
#Prerequisite: BIND'S `dig` commandline tool - Debian based installation: `apt-get install dnsutils` - MacOs homebrew installation: `brew install bind`
