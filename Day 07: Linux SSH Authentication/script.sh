#!/bin/bash

# ================================
# Password-less SSH Setup Script
# ================================

# Declare associative array: server => sudo user
declare -A servers=(
    ["stapp01"]="tony"
    ["stapp02"]="steve"
    ["stapp03"]="banner"
)

# Log file
LOG_FILE="$HOME/ssh_setup.log"
echo "=== SSH Setup Log $(date) ===" > "$LOG_FILE"

# Generate SSH key for thor if it doesn't exist
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Generating SSH key for thor..."
    ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa" | tee -a "$LOG_FILE"
else
    echo "SSH key already exists. Skipping generation." | tee -a "$LOG_FILE"
fi

# Copy public key to each app server
for server in "${!servers[@]}"; do
    user="${servers[$server]}"
    echo "Setting up password-less SSH for $user@$server..." | tee -a "$LOG_FILE"
    
    # Copy key
    if ssh-copy-id -o StrictHostKeyChecking=no "$user@$server" &>> "$LOG_FILE"; then
        echo "✅ Public key copied successfully to $user@$server" | tee -a "$LOG_FILE"
    else
        echo "❌ Failed to copy public key to $user@$server" | tee -a "$LOG_FILE"
        continue
    fi

    # Test password-less SSH
    if ssh -o BatchMode=yes -o ConnectTimeout=5 "$user@$server" "echo Connected to $server" &>> "$LOG_FILE"; then
        echo "✅ Password-less SSH verified for $user@$server" | tee -a "$LOG_FILE"
    else
        echo "❌ Password-less SSH failed for $user@$server" | tee -a "$LOG_FILE"
    fi
done

echo "✅ Password-less SSH setup completed for all reachable app servers."
echo "Check log file: $LOG_FILE for details."
