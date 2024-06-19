#!/bin/bash

# Check if a package name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PACKAGE_NAME=$1

# Configuration file path
CONFIG_FILE="/etc/nixos/configuration.nix"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found: $CONFIG_FILE"
  exit 1
fi

# Add the package to the configuration file
if grep -q "environment.systemPackages = \[.*\];" "$CONFIG_FILE"; then
  # Add the package to the existing list
  sed -i "/environment.systemPackages = \[.*\];/ s/\]/  $PACKAGE_NAME\n\]/" "$CONFIG_FILE"
else
  # Create the systemPackages section if it doesn't exist
  echo "environment.systemPackages = [ $PACKAGE_NAME ];" >> "$CONFIG_FILE"
fi

# Rebuild the NixOS configuration to apply changes
sudo nixos-rebuild switch

echo "Package '$PACKAGE_NAME' added and system rebuilt successfully."
