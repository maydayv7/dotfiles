{ config, lib, pkgs, files, ... }:
let
  enable = config.scripts.setup;
  path.system = "/etc/nixos";

  # System Setup Script
  script = with pkgs; writeScriptBin "setup"
  ''
    #!${pkgs.runtimeShell}
    set +x

    if mount | grep ext4 > /dev/null
    then
      DIR=${path.system}
    else
      DIR=/persist${path.system}
    fi

    echo "Preparing Directory..."
    sudo rm -rf $DIR
    sudo mkdir $DIR
    sudo chown $USER $DIR
    sudo chmod ugo+rw $DIR
    printf "\n"

    echo "Cloning Repo..."
    git clone https://github.com/maydayv7/dotfiles.git $DIR
    printf "\n"

    echo "Setting up User..."
    sudo mkdir -p /var/lib/AccountsService/{icons,users}
    echo "[User]" | sudo tee /var/lib/AccountsService/users/$USER &> /dev/null
    echo "Icon=/var/lib/AccountsService/icons/$USER" | sudo tee -a /var/lib/AccountsService/users/$USER &> /dev/null
    sudo cp -av $VERBOSE_ARG ${files.wallpapers}/Profile.png /var/lib/AccountsService/icons/$USER
    printf "\n"

    read -p "Enter Path to GPG Keys: " KEY
    if [ -z "$KEY" ]
    then
      error "Path to GPG Keys cannot be empty"
    fi

    echo "Importing Keys..."
    gpg --import $KEY/public.gpg
    gpg --import $KEY/private.gpg
    sudo mkdir -p /etc/gpg
    sudo gpg --homedir /etc/gpg --import $KEY/public.gpg
    sudo gpg --homedir /etc/gpg --import $KEY/private.gpg
    printf "\n"

    if [ "$DIR" == "/persist${path.system}" ]
    then
      sudo umount -l ${path.system}
      sudo mount $DIR
    fi

    sudo nixos-rebuild switch --flake ${path.system}
  '';
in rec
{
  options.scripts.setup = lib.mkEnableOption "Script for setting up NixOS";
  config = lib.mkIf enable
  {
    environment.systemPackages = [ script ];
  };
}
