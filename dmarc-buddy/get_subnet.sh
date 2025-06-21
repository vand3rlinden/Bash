#!/bin/bash

# Function to convert IP address to its integer representation
ip_to_int() {
    local IFS=.
    local ip=$1
    local -a octets
    read -r -a octets <<< "$ip"
    echo "$((octets[0] << 24 | octets[1] << 16 | octets[2] << 8 | octets[3]))"
}

# Function to convert integer representation to IP address
int_to_ip() {
    local int=$1
    echo "$((int >> 24 & 0xFF)).$((int >> 16 & 0xFF)).$((int >> 8 & 0xFF)).$((int & 0xFF))"
}

# Function to calculate subnet information
calculate_subnet() {
    local ip=$1
    local cidr=$2
    local ip_int
    local mask_int
    local network_int
    local broadcast_int
    local range_start_int
    local range_end_int
    local mask
    local network
    local broadcast
    local range_start
    local range_end

    ip_int=$(ip_to_int "$ip")
    mask_int=$((0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF))
    network_int=$((ip_int & mask_int))
    broadcast_int=$((network_int | ~mask_int & 0xFFFFFFFF))
    range_start_int=$((network_int + 1))
    range_end_int=$((broadcast_int - 1))

    mask=$(int_to_ip "$mask_int")
    network=$(int_to_ip "$network_int")
    broadcast=$(int_to_ip "$broadcast_int")
    range_start=$(int_to_ip "$range_start_int")
    range_end=$(int_to_ip "$range_end_int")

    # Output the results
    echo -e "\033[32mIP Address:\033[0m $ip"
    echo -e "\033[32mICIDR:\033[0m /$cidr"
    echo -e "\033[32mSubnet Mask:\033[0m $mask"
    echo -e "\033[32mNetwork Address:\033[0m $network"
    echo -e "\033[32mBroadcast Address:\033[0m $broadcast"
    echo -e "\033[32mUsable IP Range:\033[0m $range_start - $range_end"
}

# Main script
if [ -z "$1" ]; then
    echo "Usage: $0 <ip_address/cidr>"
    exit 1
fi

IFS=/ read -r ip cidr <<< "$1"

if [[ -z "$ip" || -z "$cidr" ]]; then
    echo "Invalid input. Usage: $0 <ip_address/cidr>"
    exit 1
fi

calculate_subnet "$ip" "$cidr"
