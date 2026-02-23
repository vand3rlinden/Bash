#!/bin/bash

# PGP Tool using GnuPG

# ─────────────────────────────────────────
#          PGP OPERATIONS FUNCTIONS
# ─────────────────────────────────────────

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

function encrypt_attachment() {
    echo "Enter recipient's email or key ID:"
    read recipient
    echo "Enter the attachment to encrypt:"
    read attachment
    gpg --encrypt --recipient "$recipient" "$attachment"
}

function decrypt_attachment() {
    echo "Enter the desired decrypted filename:"
    read filename
    echo "Enter the encrypted filename:"
    read encryptedfilename
    gpg --decrypt -o "$filename" "$encryptedfilename"
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

# ─────────────────────────────────────────
#        KEY MANAGEMENT FUNCTIONS
# ─────────────────────────────────────────

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

function sign_public_key() {
    echo "Enter the Key ID to sign:"
    read keyid
    echo "Choose signing method:"
    echo "1) Local signature (non-exportable) [gpg --lsign-key]"
    echo "2) Exportable signature [gpg --sign-key]"
    read choice
    case $choice in
        1) gpg --lsign-key "$keyid" ;;
        2) gpg --sign-key "$keyid" ;;
        *) echo "Invalid choice." ;;
    esac
}

function edit_key_trust() {
    echo "Enter the email or key ID to edit trust level:"
    read keyid
    echo "Opening interactive GPG trust editor..."
    echo "Inside GPG, use the 'trust' command to change trust level."
    echo "When finished, type 'quit' to exit."
    gpg --edit-key "$keyid"
}

# ─────────────────────────────────────────
#            KEY MANAGER MENU
# ─────────────────────────────────────────

function key_manager_menu() {
    while true; do
        echo ""
        echo "=============================="
        echo "   PGP KEY MANAGER TOOL MENU  "
        echo "=============================="
        echo "1)  Create New Key Pair"
        echo "2)  View All Keys"
        echo "3)  Import Public Key"
        echo "4)  Import Private Key"
        echo "5)  Export Public Key"
        echo "6)  Export Private Key"
        echo "7)  Remove Public Key"
        echo "8)  Remove Private Key"
        echo "9)  Sign Public Key"
        echo "10) Edit Key Trust"
        echo "11) Back to Main Menu"
        echo -n "Choose an option [1-11]: "
        read choice
        case $choice in
            1)  create_key_pair ;;
            2)  view_keys ;;
            3)  import_public_key ;;
            4)  import_private_key ;;
            5)  export_public_key ;;
            6)  export_private_key ;;
            7)  remove_public_key ;;
            8)  remove_private_key ;;
            9)  sign_public_key ;;
            10) edit_key_trust ;;
            11) echo "Returning to Main Menu..."; break ;;
            *)  echo "Invalid choice." ;;
        esac
        echo ""
    done
}

# ─────────────────────────────────────────
#              MAIN MENU
# ─────────────────────────────────────────

while true; do
    echo ""
    echo "=============================="
    echo "        PGP TOOL MENU         "
    echo "=============================="
    echo "1) Encrypt Message"
    echo "2) Decrypt Message"
    echo "3) Encrypt Attachment"
    echo "4) Decrypt Attachment"
    echo "5) Sign Message"
    echo "6) Verify Signed Message"
    echo "7) Locate Public Key (WKD)"
    echo "8) Key Manager"
    echo "9) Exit"
    echo -n "Choose an option [1-9]: "
    read choice
    case $choice in
        1) encrypt_message ;;
        2) decrypt_message ;;
        3) encrypt_attachment ;;
        4) decrypt_attachment ;;
        5) sign_message ;;
        6) verify_message ;;
        7) locate_publickey ;;
        8) key_manager_menu ;;
        9) echo "Exiting."; exit 0 ;;
        *) echo "Invalid choice." ;;
    esac
    echo ""
done