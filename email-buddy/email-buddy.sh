#!/bin/bash

############################################
#                FUNCTIONS                 #
############################################

# SPF
get_spf_record() {
    domain="$1"
    spf_record=$(dig "$domain" TXT +short | grep -E 'v=spf1')

    if [ -n "$spf_record" ]; then
        echo -e "\033[32mSPF record for $domain:\033[0m"
        echo "$spf_record"
    else
        echo -e "\033[31mNo SPF record found for $domain\033[0m"
    fi
}

# DMARC
get_dmarc_record() {
    domain="$1"
    dmarc_record=$(dig "_dmarc.$domain" TXT +short)

    if [ -n "$dmarc_record" ]; then
        echo -e "\033[32mDMARC record for $domain:\033[0m"
        echo "$dmarc_record"

        if echo "$dmarc_record" | grep -q 'p=reject'; then
            echo -e "\033[32mDomain is DMARC compliant — protected against abuse.\033[0m"
        elif echo "$dmarc_record" | grep -q 'p=quarantine'; then
            echo -e "\033[33mDomain is partially DMARC compliant.\033[0m"
        else
            echo -e "\033[31mDomain is not DMARC compliant.\033[0m"
        fi
    else
        echo -e "\033[31mNo DMARC record found for $domain\033[0m"
    fi
}

# DKIM
get_dkim_record() {
    domain="$1"
    selector="$2"

    if [ -z "$selector" ]; then
        echo -e "\033[32mPlease enter the DKIM selector:\033[0m"
        read -r selector
    fi

    dkim_record=$(dig "$selector._domainkey.$domain" TXT +short)

    if [ -n "$dkim_record" ]; then
        echo -e "\033[32mDKIM record for $selector._domainkey.$domain:\033[0m"
        echo "$dkim_record"
    else
        echo -e "\033[31mNo DKIM record found for $selector._domainkey.$domain\033[0m"
    fi
}

# MTA-STS
get_mta_sts_record() {
    domain="$1"
    mta_sts_record=$(dig "_mta-sts.$domain" TXT +short)

    if [ -n "$mta_sts_record" ]; then
        echo -e "\033[32mMTA-STS record for $domain:\033[0m"
        echo "$mta_sts_record"
        echo -e "Policy URL: \033[32mhttps://mta-sts.$domain/.well-known/mta-sts.txt\033[0m"
    else
        echo -e "\033[31mNo MTA-STS record found for $domain\033[0m"
    fi
}

# SMTP DANE
get_smtp_dane_tlsa_record() {
    domain="$1"
    mx_record=$(dig "$domain" MX +short | awk '{print $2}' | sed 's/\.$//')

    if [ -z "$mx_record" ]; then
        echo -e "\033[31mNo MX record found for $domain\033[0m"
        return
    fi

    smtp_dane_tlsa_record=$(dig "_25._tcp.$mx_record" TLSA +short)

    if [ -n "$smtp_dane_tlsa_record" ]; then
        echo -e "\033[32mSMTP DANE TLSA records for MX: $mx_record\033[0m"
        echo "$smtp_dane_tlsa_record"
    else
        echo -e "\033[31mNo SMTP DANE TLSA records found for $domain\033[0m"
    fi
}

# TLSRPT (used by MTA-STS & DANE)
get_tlsrpt_record() {
    domain="$1"
    tlsrpt_record=$(dig "_smtp._tls.$domain" TXT +short)

    if [ -n "$tlsrpt_record" ]; then
        echo -e "\033[32mTLSRPT record for $domain:\033[0m"
        echo "$tlsrpt_record"
    else
        echo -e "\033[31mNo TLSRPT record found for $domain\033[0m"
    fi
}

############################################
#                 MENU                     #
############################################

show_menu() {
    clear
    echo "=============================="
    echo "         EMAIL BUDDY"
    echo "=============================="
    echo "1) Get SPF and DMARC"
    echo "2) Get DKIM"
    echo "3) Get MTA-STS"
    echo "4) Get SMTP-DANE"
    echo "5) Exit"
    echo
    echo -n "Choose an option [1-5]: "
}

pause() {
    echo
    read -p "Press Enter to continue..."
}

############################################
#                 LOOP                     #
############################################

while true; do
    show_menu
    read choice

    case $choice in
        1)
            read -p "Enter domain: " domain
            [ -z "$domain" ] && echo "Domain cannot be empty." && pause && continue
            get_spf_record "$domain"
            get_dmarc_record "$domain"
            pause
            ;;
        2)
            read -p "Enter domain: " domain
            [ -z "$domain" ] && echo "Domain cannot be empty." && pause && continue
            read -p "Enter DKIM selector (optional): " selector
            get_dkim_record "$domain" "$selector"
            pause
            ;;
        3)
            read -p "Enter domain: " domain
            [ -z "$domain" ] && echo "Domain cannot be empty." && pause && continue
            get_mta_sts_record "$domain"
            get_tlsrpt_record "$domain"
            pause
            ;;
        4)
            read -p "Enter domain: " domain
            [ -z "$domain" ] && echo "Domain cannot be empty." && pause && continue
            get_smtp_dane_tlsa_record "$domain"
            get_tlsrpt_record "$domain"
            pause
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option."
            pause
            ;;
    esac
done