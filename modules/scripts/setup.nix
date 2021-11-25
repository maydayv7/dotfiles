{ config, lib, pkgs, files, ... }:
let
  enable = config.scripts.setup;
  secrets = config.age.secrets;

  # System Setup Script
  script = with pkgs; writeScriptBin "setup"
  ''
    #!${pkgs.runtimeShell}
    set +x

    if mount | grep ext4 > /dev/null
    then
      DIR=/etc/nixos
    else
      DIR=/persist/etc/nixos
    fi

    echo "Preparing Directory..."
    sudo rm -rf $DIR
    sudo mkdir $DIR
    sudo chown $USER $DIR
    sudo chmod ugo+rw $DIR
    printf "\n"

    echo "Cloning Repo..."
    git clone --recurse-submodules https://github.com/maydayv7/dotfiles.git $DIR
    printf "\n"

    echo "Setting up User..."
    mkdir -p ~/Pictures/Screenshots
    sudo mkdir -p /var/lib/AccountsService/{icons,users}
    echo "[User]" | sudo tee /var/lib/AccountsService/users/$USER &> /dev/null
    echo "Icon=/var/lib/AccountsService/icons/$USER" | sudo tee -a /var/lib/AccountsService/users/$USER &> /dev/null
    sudo cp -av $VERBOSE_ARG ${files.wallpapers}/Profile.png /var/lib/AccountsService/icons/$USER
    printf "\n"

    echo "Importing Keys..."
    sudo ssh-add /etc/ssh/ssh_key
    mkdir -p ~/.gnupg
    gpg --import ${secrets."gpg/public.gpg".path}
    gpg --import ${secrets."gpg/private.gpg".path}
    printf "\n"

    if [ "$DIR" == "/persist/etc/nixos" ]
    then
      sudo umount -l /etc/nixos
      sudo mount $DIR
    fi

    nixos apply
  '';
in rec
{
  options.scripts.setup = lib.mkOption
  {
    description = "Script for setting up NixOS";
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf enable
  {
    environment.systemPackages = [ script ];
  };
}
