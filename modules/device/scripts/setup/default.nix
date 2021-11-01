{ config, lib, pkgs, ... }:
let
  cfg = config.scripts.setup;
  script = with pkgs; writeScriptBin "setup"
  ''
    #!${pkgs.runtimeShell}
    set +x

    read -p "Enter Github authentication token: " KEY

    if mount | grep ext4 > /dev/null; then
      DIR=/etc
    else
      DIR=/persist/etc
    fi

    echo "Preparing Directory..."
    sudo rm -rf $DIR/nixos
    sudo mkdir $DIR/nixos
    sudo chown $USER $DIR/nixos
    sudo chmod ugo+rw $DIR/nixos
    printf "\n"

    echo "Cloning Repo..."
    git clone --recurse-submodules https://github.com/maydayv7/dotfiles.git $DIR/nixos
    mkdir -p ~/.config/nix && echo "access-tokens = github.com=$KEY" >> ~/.config/nix/nix.conf
    printf "\n"

    echo "Applying Device Configuration..."
    sudo nixos-rebuild switch --flake $DIR/nixos#
    printf "\n"

    echo "Applying User Configuration..."
    nix build $DIR/nixos#homeConfigurations.$USER.activationPackage
    ./result/activate
    rm -rf ./result
    printf "\n"

    read -p "Do you want to reboot the system? (Y/N): " choice
      case $choice in
        [Yy]* ) reboot;;
        [Nn]* ) exit;;
        * ) echo "Please answer (Y)es or (N)o.";;
      esac
  '';
in rec
{
  options.scripts.setup = lib.mkOption
  {
    description = "Script for setting up NixOS";
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (cfg == true)
  {
    environment.systemPackages = [ script ]; 
  };
}
