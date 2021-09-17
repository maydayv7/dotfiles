#! /usr/bin/env bash

# Shows the output of every command
set +x

# System Setup
setup_system()
{
  printf "Setting up System...\nDeleting /etc/nixos -> "
  sudo rm -rf /etc/nixos
}

# Setup for User V7
setup_v7()
{
  printf "Setting up User V7...\nCreating Screenshots Directory -> "
  mkdir -p /home/v7/Pictures/Screenshots
  printf "Setting Profile Picture -> "
  sudo cp -av /home/v7/.local/share/backgrounds/Profile.png /var/lib/AccountsService/icons/v7
}

# Setup for User V7
rebuild()
{
  printf "Rebuilding System... ->\n"
  sudo nixos-rebuild switch -I nixos-config=./configuration.nix
}

read -p "Do you want to setup the system? (Y/N): " choice
  case $choice in
      [Yy]* ) setup_system; printf "\n";;
      [Nn]* ) printf "\n";;
      * ) echo "Please answer (Y)es or (N)o.";;
  esac

read -p "Do you want to setup user V7? (Y/N): " choice
  case $choice in
      [Yy]* ) setup_v7; printf "\n";;
      [Nn]* ) printf "\n";;
      * ) echo "Please answer (Y)es or (N)o.";;
  esac

read -p "Do you want to rebuild the system? (Y/N): " choice
  case $choice in
      [Yy]* ) rebuild; exit;;
      [Nn]* ) exit;;
      * ) echo "Please answer (Y)es or (N)o.";;
  esac
