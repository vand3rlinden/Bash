#!/bin/bash

# Set sender (P2 sender) and recipient email addresses
sender="Firstname Lastname <p2sender@domain.com>" # P2 Sender
recipient="ricardo@example.com"

# Set return path sender (P1 sender)
return_path_sender="p1sender@domain.com" # P1 Sender

# Set subject and message body
subject="EHLO World"
body="Hi,\n\nThis is a test email.\n\nBest regards,\nSomeone"

# Send the email using mail command from mailutils
echo -e "$headers\n$body" | mail -a "From: $sender" -a "Return-Path: $return_path_sender" "$recipient" -s "$subject"

#You can change the P1 sender domain by modifying the return_path_sender line for the testing DMARC-compliant for the P2 sender.
#Prerequisites: Postfix (sudo apt-get install postfix) and Mailutils (sudo apt-get install mailutils)
