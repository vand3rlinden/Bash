#!/bin/bash

# Function to retrieve SPF record for a domain
get_spf_record() {
    domain="$1"
    spf_record=$(dig "$domain" TXT +short | grep -E 'v=spf1')
    if [ -n "$spf_record" ]; then
        echo "SPF record for $domain:"
        echo "$spf_record"
    else
        echo "No SPF record found for $domain"
    fi
}

# Function to retrieve DMARC record for a domain
get_dmarc_record() {
    domain="$1"
    dmarc_record=$(dig "_dmarc.$domain" TXT +short)
    if [ -n "$dmarc_record" ]; then
        echo "DMARC record for $domain:"
        echo "$dmarc_record"
    else
        echo "No DMARC record found for $domain"
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
