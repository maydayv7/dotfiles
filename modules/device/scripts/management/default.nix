{ config, lib, pkgs, ... }:
let
  cfg = config.scripts.management;

  # System Management Script
  script = with pkgs; writeScriptBin "nixos"
  ''
    #!${pkgs.runtimeShell}
    case $1 in
    "update")
      echo "Updating Flake Inputs..."
      nix flake update /etc/nixos $2
    ;;
    "apply")
      echo "Applying Device Settings..."
      sudo nixos-rebuild switch --flake /etc/nixos#
      printf "\n"
      echo "Applying User Settings..."
      nix build /etc/nixos#homeConfigurations.$USER.activationPackage && ./result/activate && rm -rf ./result
    ;;
    "apply-device")
      echo "Applying Device Settings..."
      if [ -z "$2" ]; then
        sudo nixos-rebuild switch --flake /etc/nixos#
      elif [ $2 = "--boot" ]; then
        sudo nixos-rebuild boot --flake /etc/nixos#
      elif [ $2 = "--test" ]; then
        sudo nixos-rebuild test --flake /etc/nixos#
      elif [ $2 = "--check" ]; then
        nixos-rebuild dry-activate --flake /etc/nixos#
      else
        echo "Unknown option $2"
      fi
    ;;
    "apply-user")
      echo "Applying User Settings..."
      nix build /etc/nixos#homeConfigurations.$USER.activationPackage && ./result/activate && rm -rf ./result
   ;;
   "iso")
     echo "Building $2 ISO file..."
     nix build /etc/nixos#installMedia.$2.config.system.build.isoImage && echo "The image is located at ./result/iso/nixos.iso"
     if [ -z "$3" ]; then
       echo "The --burn option can be used to burn the image to a USB"
     elif [ $3 = "--burn" ]; then
       if [ -z "$4" ]; then
         echo "Expected a path to USB drive following --burn"
       else
         sudo dd if=./result/iso/nixos.iso of=$4 status=progress bs=1M
       fi
     else
       echo "Unexpected option $3"
     fi
    ;;
    "shell")
      if [ -z "$2" ]; then
        nix develop /etc/nixos
      else
        nix develop /etc/nixos#$2
      fi
    ;;
    "list")
      nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq
    ;;
    "save")
      echo "Saving Changes..."
      pushd /etc/nixos
      git add .
      read -p "Enter comment: " comment
      git commit -m "$(echo $comment)"
      git pull --rebase
      git push
      popd
    ;;
    "clean")
      echo "Running Garbage Collection..."
      nix store gc
      printf "\n"
      echo "Running De-Duplication..."
      nix store optimise
    ;;
    *)
      echo "########################## Tool for NixOS System Management ##########################"
      echo "Usage :-"
      echo "update                        - Updates Nix Flake Inputs"
      echo "apply                         - Applies both Device and User Configuration"
      echo "apply-device [ --'option' ]   - Applies Device Configuration"
      echo "apply-user                    - Applies User Home configuration"
      echo "iso 'image' [ --burn 'path' ] - Builds Install Media and optionally burns it to USB"
      echo "shell [ 'name' ]              - Opens desired Nix Developer Shell"
      echo "list                          - Lists all Installed Packages"
      echo "save                          - Saves Configuration State to Repository"
      echo "clean                         - Garbage Collects and Hard-Links Nix Store"
    ;;
    esac
  '';
in rec
{
  options.scripts.management = lib.mkOption
  {
    description = "Script for NixOS System Management";
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (cfg == true)
  {
    environment.systemPackages = [ script ]; 
  };
}
