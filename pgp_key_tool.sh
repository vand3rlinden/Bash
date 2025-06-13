#!/bin/bash

# GPG Key Management Tool using GnuPG

function create_key_pair() {
    echo "Creating a new GPG key pair..."
    gpg --full-generate-key
}

function view_keys() {
    echo "Public Keys:"
    gpg --list-keys
    echo ""
    echo "Private Keys:"
    gpg --list-secret-keys
}

function import_public_key() {
    echo "Enter the path to the public key file:"
    read file
    gpg --import "$file"
}

function import_private_key() {
    echo "Enter the path to the private key file:"
    read file
    gpg --import "$file"
}

function export_public_key() {
    echo "Enter the email or key ID to export:"
    read keyid
    echo "Enter output file name (e.g., public.asc):"
    read outfile
    gpg --armor --export "$keyid" > "$outfile"
    echo "Public key exported to $outfile"
}

function export_private_key() {
    echo "Enter the email or key ID to export:"
    read keyid
    echo "Enter output file name (e.g., private.asc):"
    read outfile
    gpg --armor --export-secret-keys "$keyid" > "$outfile"
    echo "Private key exported to $outfile"
}

function remove_public_key() {
    echo "Enter the email or key ID of the public key to delete:"
    read keyid
    gpg --delete-key "$keyid"
}

function remove_private_key() {
    echo "Enter the email or key ID of the private key to delete:"
    read keyid
    gpg --delete-secret-key "$keyid"
}

function show_menu() {
    echo "=============================="
    echo "  PGP KEY MANAGER TOOL MENU"
    echo "=============================="
    echo "1) Create New Key Pair"
    echo "2) View All Keys"
    echo "3) Import Public Key"
    echo "4) Import Private Key"
    echo "5) Export Public Key"
    echo "6) Export Private Key"
    echo "7) Remove Public Key"
    echo "8) Remove Private Key"
    echo "9) Exit"
    echo -n "Choose an option [1-9]: "
}

while true; do
    show_menu
    read choice
    case $choice in
        1) create_key_pair ;;
        2) view_keys ;;
        3) import_public_key ;;
        4) import_private_key ;;
        5) export_public_key ;;
        6) export_private_key ;;
        7) remove_public_key ;;
        8) remove_private_key ;;
        9) echo "Exiting."; break ;;
        *) echo "Invalid choice." ;;
    esac
    echo ""
done
