#!/bin/bash

# Set sender and recipient email addresses
sender="P2 Sender <p2sender@domain.com>"
recipient="ricardo@example.com"

# Set return path sender (P1 sender)
return_path_sender="p1sender@domain.com"

# Set subject and message body
subject="Hello Ricardo!"
body="Hi Ricardo,\n\nThis is a test email.\n\nBest regards,\nSomeone"

# Send the email using mail command from mailutils
echo -e "$headers\n$body" | mail -a "From: $sender" -a "Return-Path: $return_path_sender" "$recipient" -s "$subject"

#You can change the P1 sender domain by modifying the return_path_sender line for the testing DMARC-compliant for the P2 sender or testing out SPF macro's for your domain.
#Prerequisites: Postfix (sudo apt-get install postfix) and Mailutils (sudo apt-get install mailutils)
