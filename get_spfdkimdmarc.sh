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

# Function to retrieve DKIM record for a domain (selectors for Microsoft 365)
get_dkim_record() {
    domain="$1"
    selectors=("selector1" "selector2")
    for selector in "${selectors[@]}"; do
        dkim_record=$(dig "$selector._domainkey.$domain" TXT +short)
        if [ -n "$dkim_record" ]; then
            echo "DKIM record for $selector.$domain:"
            echo "$dkim_record"
        else
            echo "No DKIM record found for $selector.$domain"
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
