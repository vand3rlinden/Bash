#!/bin/bash

SPF_DMARC_SCRIPT="./scripts/get_spfdmarc.sh"
DKIM_SCRIPT="./scripts/get_dkim.sh"
MTA_STS_SCRIPT="./scripts/get_mta-sts.sh"
SMTP_DANE_SCRIPT="./scripts/get_smtp-dane.sh"

function show_menu() {
    clear
    echo "=============================="
    echo "     MAIL BUDDY MENU"
    echo "=============================="
    echo "1) Get SPF and DMARC"
    echo "2) Get DKIM"
    echo "3) Get MTA-STS"
    echo "4) Get SMTP-DANE"
    echo "5) Exit"
    echo
    echo -n "Choose an option [1-5]: "
}

function pause() {
    echo
    read -p "Press Enter to continue..."
}

while true; do
    show_menu
    read choice

    case $choice in
        1)
            read -p "Enter domain: " domain
            if [[ -z "$domain" ]]; then
                echo "Domain cannot be empty."
            else
                bash "$SPF_DMARC_SCRIPT" "$domain"
            fi
            pause
            ;;
        2)
            read -p "Enter domain: " domain
            if [[ -z "$domain" ]]; then
                echo "Domain cannot be empty."
                pause
                continue
            fi

            read -p "Enter DKIM selector (optional): " selector

            if [[ -z "$selector" ]]; then
                bash "$DKIM_SCRIPT" "$domain"
            else
                bash "$DKIM_SCRIPT" "$domain" "$selector"
            fi
            pause
            ;;
        3)
            read -p "Enter domain: " domain
            if [[ -z "$domain" ]]; then
                echo "Domain cannot be empty."
            else
                bash "$MTA_STS_SCRIPT" "$domain"
            fi
            pause
            ;;
        4)
            read -p "Enter domain: " domain
            if [[ -z "$domain" ]]; then
                echo "Domain cannot be empty."
            else
                bash "$SMTP_DANE_SCRIPT" "$domain"
            fi
            pause
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose between 1 and 5."
            pause
            ;;
    esac
done