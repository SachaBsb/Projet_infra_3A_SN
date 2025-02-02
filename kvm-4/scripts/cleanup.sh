#!/bin/bash

# Function to display messages
log() {
  echo "[INFO] $1"
}

# Cleanup all domains
cleanup_domains() {
  log "Cleaning up all domains..."
  
  # List all domains
  domains=$(virsh list --all --name)
  
  # Loop through and destroy/undefine each domain
  for domain in $domains; do
    if [[ -n "$domain" ]]; then
      log "Destroying domain: $domain"
      virsh destroy "$domain" 2>/dev/null
      
      log "Undefining domain: $domain"
      virsh undefine "$domain" 2>/dev/null
    fi
  done

  log "All domains cleaned up."
}

# Cleanup all volumes
cleanup_volumes() {
  POOL_NAME="$1"
  EXCLUDE_IMAGE="ubuntu-base.qcow2"

  if [[ -z "$POOL_NAME" ]]; then
    log "No pool name provided. Please provide a pool name."
    exit 1
  fi

  log "Cleaning up all volumes in pool: $POOL_NAME..."
  
  # List all volumes in the pool
  volumes=$(virsh vol-list "$POOL_NAME" | awk 'NR>2 {print $1}' | grep -v '^$')
  
  # Loop through and delete each volume
  for volume in $volumes; do
    # if [[ "$volume" != "$EXCLUDE_IMAGE" ]]; then
    #   log "The volume $volume is detected as "
    # fi
    if [[ -n "$volume" && "$volume" != "$EXCLUDE_IMAGE" ]]; then
      log "Deleting volume: $volume"
      virsh vol-delete "$volume" --pool "$POOL_NAME"
    fi
  done

  log "All volumes in pool '$POOL_NAME' cleaned up."
}

destroy_terraform() {
  # Run terraform destroy
  log "Running Terraform to destroy infrastructure"
  terraform destroy -auto-approve || {
    log "Error: Terraform destroy failed"
  }
}

# Main script
main() {
  # Check if the script is run as root
  if [[ "$EUID" -ne 0 ]]; then
    log "This script must be run as root."
    exit 1
  fi

  # Cleanup domains
  cleanup_domains
  
  # Cleanup volumes (default pool: 'default')
  POOL_NAME=${1:-default}
  cleanup_volumes "$POOL_NAME"
  
  # Destroy Terraform infrastructure
  destroy_terraform

  log "Cleanup completed."
}

# Run the main function with the pool name as an argument
main "$@"
