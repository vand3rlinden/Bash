#!/bin/bash

# PGP Tool using GnuPG

GREEN='\033[0;32m'
NC='\033[0m'

# ─────────────────────────────────────────
#          PGP OPERATIONS FUNCTIONS
# ─────────────────────────────────────────

function encrypt_message() {
    echo -e "${GREEN}Enter recipient's email or key ID:${NC}"
    read recipient
    echo -e "${GREEN}Enter the message to encrypt (end with Ctrl+D):${NC}"
    gpg --armor --encrypt --recipient "$recipient"
}

function decrypt_message() {
    echo -e "${GREEN}Paste the encrypted message below (end with Ctrl+D):${NC}"
    gpg --decrypt
}

function encrypt_attachment() {
    echo -e "${GREEN}Enter recipient's email or key ID:${NC}"
    read recipient
    echo -e "${GREEN}Enter the attachment to encrypt:${NC}"
    read attachment
    gpg --encrypt --recipient "$recipient" "$attachment"
}

function decrypt_attachment() {
    echo -e "${GREEN}Enter the desired decrypted filename:${NC}"
    read filename
    echo -e "${GREEN}Enter the encrypted filename:${NC}"
    read encryptedfilename
    gpg --decrypt -o "$filename" "$encryptedfilename"
}

function sign_message() {
    echo -e "${GREEN}Enter your key ID or email (for signing):${NC}"
    read signer
    echo -e "${GREEN}Enter the message to sign (end with Ctrl+D):${NC}"
    gpg --armor --clearsign --local-user "$signer"
}

function verify_message() {
    echo -e "${GREEN}Paste the signed message below (end with Ctrl+D):${NC}"
    gpg --verify
}

function locate_publickey() {
    echo -e "${GREEN}Enter an email address to locate:${NC}"
    read email
    gpg --locate-keys "$email"
}

# ─────────────────────────────────────────
#        KEY MANAGEMENT FUNCTIONS
# ─────────────────────────────────────────

function create_key_pair() {
    echo -e "${GREEN}Creating a new GPG key pair...${NC}"
    gpg --full-generate-key
}

function view_keys() {
    echo -e "${GREEN}Public Keys:${NC}"
    gpg --list-keys
    echo ""
    echo -e "${GREEN}Private Keys:${NC}"
    gpg --list-secret-keys
}

function import_public_key() {
    echo -e "${GREEN}Enter the path to the public key file:${NC}"
    read file
    gpg --import "$file"
}

function import_private_key() {
    echo -e "${GREEN}Enter the path to the private key file:${NC}"
    read file
    gpg --import "$file"
}

function export_public_key() {
    echo -e "${GREEN}Enter the email or key ID to export:${NC}"
    read keyid
    echo -e "${GREEN}Enter output file name (e.g., public.asc):${NC}"
    read outfile
    gpg --armor --export "$keyid" > "$outfile"
    echo -e "${GREEN}Public key exported to $outfile${NC}"
}

function export_private_key() {
    echo -e "${GREEN}Enter the email or key ID to export:${NC}"
    read keyid
    echo -e "${GREEN}Enter output file name (e.g., private.asc):${NC}"
    read outfile
    gpg --armor --export-secret-keys "$keyid" > "$outfile"
    echo -e "${GREEN}Private key exported to $outfile${NC}"
}

function remove_public_key() {
    echo -e "${GREEN}Enter the email or key ID of the public key to delete:${NC}"
    read keyid
    gpg --delete-key "$keyid"
}

function remove_private_key() {
    echo -e "${GREEN}Enter the email or key ID of the private key to delete:${NC}"
    read keyid
    gpg --delete-secret-key "$keyid"
}

function sign_public_key() {
    echo -e "${GREEN}Enter the Key ID to sign:${NC}"
    read keyid
    echo -e "${GREEN}Choose signing method:${NC}"
    echo -e "${GREEN}1) Local signature (non-exportable) [gpg --lsign-key]${NC}"
    echo -e "${GREEN}2) Exportable signature [gpg --sign-key]${NC}"
    read choice
    case $choice in
        1) gpg --lsign-key "$keyid" ;;
        2) gpg --sign-key "$keyid" ;;
        *) echo -e "${GREEN}Invalid choice.${NC}" ;;
    esac
}

function edit_key_trust() {
    echo -e "${GREEN}Enter the email or key ID to edit trust level:${NC}"
    read keyid
    echo -e "${GREEN}Opening interactive GPG trust editor...${NC}"
    echo -e "${GREEN}Inside GPG, use the 'trust' command to change trust level.${NC}"
    echo -e "${GREEN}When finished, type 'quit' to exit.${NC}"
    gpg --edit-key "$keyid"
}

# ─────────────────────────────────────────
#            KEY MANAGER MENU
# ─────────────────────────────────────────

function key_manager_menu() {
    while true; do
        echo ""
        echo -e "${GREEN}==============================${NC}"
        echo -e "${GREEN}   PGP KEY MANAGER TOOL MENU  ${NC}"
        echo -e "${GREEN}==============================${NC}"
        echo -e "${GREEN}1)  Create New Key Pair${NC}"
        echo -e "${GREEN}2)  View All Keys${NC}"
        echo -e "${GREEN}3)  Import Public Key${NC}"
        echo -e "${GREEN}4)  Import Private Key${NC}"
        echo -e "${GREEN}5)  Export Public Key${NC}"
        echo -e "${GREEN}6)  Export Private Key${NC}"
        echo -e "${GREEN}7)  Remove Public Key${NC}"
        echo -e "${GREEN}8)  Remove Private Key${NC}"
        echo -e "${GREEN}9)  Sign Public Key${NC}"
        echo -e "${GREEN}10) Edit Key Trust${NC}"
        echo -e "${GREEN}11) Back to Main Menu${NC}"
        echo -en "${GREEN}Choose an option [1-11]: ${NC}"
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
            11) echo -e "${GREEN}Returning to Main Menu...${NC}"; break ;;
            *)  echo -e "${GREEN}Invalid choice.${NC}" ;;
        esac
        echo ""
    done
}

# ─────────────────────────────────────────
#              MAIN MENU
# ─────────────────────────────────────────

while true; do
    echo ""
    echo -e "${GREEN}==============================${NC}"
    echo -e "${GREEN}        PGP TOOL MENU         ${NC}"
    echo -e "${GREEN}==============================${NC}"
    echo -e "${GREEN}1) Encrypt Message${NC}"
    echo -e "${GREEN}2) Decrypt Message${NC}"
    echo -e "${GREEN}3) Encrypt Attachment${NC}"
    echo -e "${GREEN}4) Decrypt Attachment${NC}"
    echo -e "${GREEN}5) Sign Message${NC}"
    echo -e "${GREEN}6) Verify Signed Message${NC}"
    echo -e "${GREEN}7) Locate Public Key (WKD)${NC}"
    echo -e "${GREEN}8) Key Manager${NC}"
    echo -e "${GREEN}9) Exit${NC}"
    echo -en "${GREEN}Choose an option [1-9]: ${NC}"
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
        9) echo -e "${GREEN}Exiting.${NC}"; exit 0 ;;
        *) echo -e "${GREEN}Invalid choice.${NC}" ;;
    esac
    echo ""
done