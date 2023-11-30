#! /usr/bin/env nix
#! nix shell nixpkgs#{bash,coreutils,gnused,libpst} -c bash

# Script to convert '.pst' Files to '.mbox' #

MAIL=./convert-$(date '+%H-%M_%d-%m-%y')

# File Conversion
read -rp "Enter Path to '.pst' File: " DIR
echo "Converting '.pst' to '.mbox'"
mkdir "$MAIL" && readpst -o "$MAIL" -r "$DIR"
find "$MAIL" -type d -mindepth 1 | tac | xargs -d '\n' -I{} mv {} {}.sbd
find "$MAIL" -name mbox -type f | xargs -d '\n' -I{} echo '"{}" "{}"' | sed -e 's/\.sbd\/mbox"$/"/' | xargs -L 1 mv
find "$MAIL" -empty -type d | xargs -d '\n' rmdir
find "$MAIL" -type d | grep -E '.sbd' | sed 's/.\{4\}$//' | xargs -d '\n' touch
echo "Conversion Complete, Files are Present in $MAIL"

# Mail Import
import() {
read -rp "Enter Name of Thunderbird Profile: " PROFILE
cp -r "$MAIL"/. "$HOME/.thunderbird/$PROFILE/Mail/Local Folders/Converted/" && echo "Successfully Imported"
}

read -rp "Do you want to Import the Mails into Thunderbird? (Y/N): " choice
  case $choice in
    [Yy]*) import; rm -rf "$MAIL";;
    *) rm -rf "$MAIL"; exit;;
  esac
