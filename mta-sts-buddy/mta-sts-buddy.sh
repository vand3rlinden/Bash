#!/bin/bash

# Function to retrieve the MTA STS record for a domain
get_mta_sts_record() {
    domain="$1"
    mta_sts_record=$(dig "_mta-sts.$domain" TXT +short)
    if [ -n "$mta_sts_record" ]; then
        echo -e "\033[32mMTA STS record for $domain:\033[0m"
        echo "$mta_sts_record"
        echo -e "MTA STS policy hosted at: \033[32mhttps://mta-sts.$domain/.well-known/mta-sts.txt\033[0m"
    else
        echo -e "\033[32mNo MTA STS record found for $domain\033[0m"
    fi
}

# Function to retrieve the TLSRPT record for a domain
get_tlsrpt_record() {
    domain="$1"
    get_tlsrpt_record=$(dig "_smtp._tls.$domain" TXT +short)
    if [ -n "$get_tlsrpt_record" ]; then
        echo -e "\033[32mTLSRPT record for $domain:\033[0m"
        echo "$get_tlsrpt_record"
    else
        echo -e "\033[32mNo TLSRPT record found for $domain\033[0m"
    fi
}

# Main script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi
	domain="$1"

get_mta_sts_record "$domain"
get_tlsrpt_record "$domain"