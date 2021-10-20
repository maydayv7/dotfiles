#! /usr/bin/env bash
# My NixOS Setup Script

# Shows the output of every command
set +x

# Privilege Escalation
sudo -v

# System Setup
function setup_system()
{
  read -p "Do you want to setup the system? (Y/N): " choice
    case $choice in
      [Yy]* ) ;;
      [Nn]* ) exit;;
      * ) echo "Please answer (Y)es or (N)o.";;
    esac
  printf "<----------- Setting up System ------------>"
  printf "\n"
  # Install Required Packages
  nix-env -iA nixos.nixUnstable nixos.git nixos.git-crypt nixos.gnupg
  # Nix Flakes Support
  rm -f $HOME/.config/nix/nix.conf
  echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf
  # GPG Keys Import
  gpg --import ./secrets/gpg/public.gpg
  gpg --import ./secrets/gpg/private.gpg
  printf "\n"
  printf "<----------- Setting up Device ------------>"
  printf "\n"
  read -p "Do you want to setup the device Vortex or Futura? (1/2): " choice
    case $choice in
      [1]* ) device=Vortex; printf "\n"; setup_v7;;
      [2]* ) device=Futura; printf "\n"; setup_navya;;
      * ) echo "Please answer (1)Vortex or (2)Futura.";;
    esac
}

# Setup for User V7
function setup_v7()
{
  printf "<----------- Setting up User V7 ----------->"
  printf "\n"
  USER=v7
  # Create Screenshots Directory
  mkdir -p /home/v7/Pictures/Screenshots
  # Set Profile Picture
  sudo cp -av ./users/dotfiles/images/Profile.png /var/lib/AccountsService/icons/v7
}

# Setup for User Navya
function setup_navya()
{
  printf "<--------- Setting up User Navya ---------->"
  printf "\n"
  USER=navya
  # Create Screenshots Directory
  mkdir -p /home/navya/Pictures/Screenshots
  # Set Profile Picture
  sudo cp -av ./users/dotfiles/images/Profile.png /var/lib/AccountsService/icons/navya
}

# Rebuild System
function rebuild()
{
  read -p "Do you want to rebuild the system? (Y/N): " choice
    case $choice in
      [Yy]* ) ;;
      [Nn]* ) exit;;
      * ) echo "Please answer (Y)es or (N)o.";;
    esac
  printf "<----------- Rebuilding System ------------>"
  printf "\n"
  sudo nixos-rebuild switch --flake .#$device
}

# Function Call
setup_system
printf "\n"
rebuild
printf "\n"
nixos apply-user
