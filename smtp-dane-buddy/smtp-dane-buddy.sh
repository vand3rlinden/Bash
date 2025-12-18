#!/bin/bash

# Function to retrieve the SMTP DANE's TLSA records for a domain
get_smtp_dane_tlsa_record() {
    domain="$1"
    mx_record=$(dig "$domain" MX +short | awk '{print $2}' | sed 's/\.$//')
    smtp_dane_tlsa_record=$(dig "_25._tcp.$mx_record" TLSA +short)
    if [ -n "$smtp_dane_tlsa_record" ]; then
        echo -e "\033[32mSMTP DANE's TLSA records for $domain's MX record: $mx_record\033[0m"
        echo "$smtp_dane_tlsa_record"
    else
        echo -e "\033[32mNo SMTP DANE's TLSA records found for $domain\033[0m"
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

get_smtp_dane_tlsa_record "$domain"
get_tlsrpt_record "$domain"