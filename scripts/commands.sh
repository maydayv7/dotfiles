#! /usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#bzip2 nixpkgs#coreutils nixpkgs#git nixpkgs#gnupg nixpkgs#gnutar nixpkgs#gzip nixpkgs#p7zip nixpkgs#unzip -c bash

# Useful Commands #

temp(){
  TEMP=/tmp/"$1"
  rm -rf "$TEMP"
  mkdir -p "$TEMP"
}

extract() {
  if [ -f "$1" ]
  then
    case $1 in
    *.tar.bz2) tar xvjf "$1";;
    *.tar.gz) tar xvzf "$1";;
    *.tar.xz) tar Jxvf "$1";;
    *.bz2) bunzip2 "$1";;
    *.rar) rar x "$1";;
    *.gz) gunzip "$1";;
    *.tar) tar xvf "$1";;
    *.tbz2) tar xvjf "$1";;
    *.tgz) tar xvzf "$1";;
    *.zip) unzip -d "${1//\.zip/}" "$1";;
    *.Z) uncompress "$1";;
    *.7z) 7z x "$1";;
    *) error "Can't Extract '$1'" ;;
    esac
  else
    error "File '$1' is invalid"
  fi
}

up() {
  LIMIT=$1
  P=$PWD/..
  for ((i=1; i < LIMIT; i++))
  do
    P=$P/..
  done
  cd "$P" || exit
}

internet() {
  if ! nc -zw1 google.com 443 2> /dev/null
  then
    error "You are Offline, Please Connect to the Internet"
  fi
}

restart() {
  read -rp "Do you want to Reboot the System? (Y/N): " choice
    case $choice in
      [Yy]*) reboot;;
      *) exit;;
    esac
}

# Print

newline() {
  echo -e "\n";
}

error() {
  echo -e "\n\033[0;31merror:\033[0m $1"
  if [ -n "$2" ]
  then
    echo -e "\n$2"
  fi
  exit 7
}

info() {
  echo -e "\n\033[0;35minfo:\033[0m $1"
  if [ -n "$2" ]
  then
    echo -e "\n$2"
  fi
}

warn() {
  echo -e "\n\033[0;35mwarning:\033[0m $1"
  if [ -n "$2" ]
  then
    echo -e "\n$2"
  fi
}
