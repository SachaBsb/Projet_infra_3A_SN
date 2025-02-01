#!/bin/bash

echo "================================="
echo "SSH Key Generation Script"
echo "================================="
echo "This script will generate a new SSH key pair for Ansible."
echo "Existing keys will be replaced if they already exist."
echo

# Define paths
KEY_DIR="$HOME/.ssh"
PRIVATE_KEY="$KEY_DIR/ansible_rsa"
PUBLIC_KEY="$PRIVATE_KEY.pub"
OUTPUT_DIR="data"
OUTPUT_FILE="$OUTPUT_DIR/ansible_rsa.pub"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Remove existing keys if they exist
if [ -f "$PRIVATE_KEY" ] || [ -f "$PUBLIC_KEY" ]; then
    echo "Existing SSH key found. Replacing..."
    rm -f "$PRIVATE_KEY" "$PUBLIC_KEY"
    echo "Old keys removed."
    echo
fi

# Generate a new SSH key pair
echo "Generating a new SSH key..."
ssh-keygen -t rsa -b 4096 -f "$PRIVATE_KEY" -N "" -q
echo "New SSH key created."
echo

# Copy the public key to the output directory
cp "$PUBLIC_KEY" "$OUTPUT_FILE"
echo "Public key saved to: $OUTPUT_FILE"
echo
