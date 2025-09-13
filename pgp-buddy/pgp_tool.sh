#!/bin/bash

# PGP Tool using GnuPG

function encrypt_message() {
    echo "Enter recipient's email or key ID:"
    read recipient
    echo "Enter the message to encrypt (end with Ctrl+D):"
    gpg --armor --encrypt --recipient "$recipient"
}

function decrypt_message() {
    echo "Paste the encrypted message below (end with Ctrl+D):"
    gpg --decrypt
}

function sign_message() {
    echo "Enter your key ID or email (for signing):"
    read signer
    echo "Enter the message to sign (end with Ctrl+D):"
    gpg --armor --clearsign --local-user "$signer"
}

function verify_message() {
    echo "Paste the signed message below (end with Ctrl+D):"
    gpg --verify
}

function locate_publickey() {
    echo "Enter an email address to locate:"
    read email
    gpg --locate-keys "$email"
}

function show_menu() {
    echo "=============================="
    echo "     PGP TOOL MENU"
    echo "=============================="
    echo "1) Encrypt Message"
    echo "2) Decrypt Message"
    echo "3) Sign Message"
    echo "4) Verify Signed Message"
    echo "5) Locate Public Key (WKD)"
    echo "6) Exit"
    echo -n "Choose an option [1-6]: "
}

while true; do
    show_menu
    read choice
    case $choice in
        1) encrypt_message ;;
        2) decrypt_message ;;
        3) sign_message ;;
        4) verify_message ;;
        5) locate_publickey ;;
        6) echo "Exiting."; break ;;
        *) echo "Invalid choice." ;;
    esac
    echo ""
done