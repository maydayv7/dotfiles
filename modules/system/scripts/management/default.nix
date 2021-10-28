{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.scripts.management;
  script = with pkgs; writeScriptBin "nixos"
  ''
    #!${pkgs.runtimeShell}
    if [ -n "$INNIXSHELLHOME" ]; then
      echo "You are in a Nix Shell that redirected ~"
      echo "The tool cannot work here properly"
      exit 1
    fi
    
    case $1 in
    "clean")
      echo "Running Garbage Collection..."
      nix-store --gc
      printf "\n"
      echo "Running De-Duplication..."
      nix-store --optimise
    ;;
    "update")
      echo "Updating Flake Inputs..."
      nix flake update /etc/nixos
    ;;
    "apply")
      echo "Applying Device Settings..."
      sudo nixos-rebuild switch --flake /etc/nixos#
      printf "\n"
      echo "Applying User Settings..."
      nix build /etc/nixos#homeConfigurations.$USER.activationPackage
      ./result/activate
      rm -rf ./result
    ;;
    "apply-system")
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
      rm -rf ./result
    ;;
    "apply-user")
      echo "Applying User Settings..."
      nix build /etc/nixos#homeConfigurations.$USER.activationPackage
      ./result/activate
      rm -rf ./result
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
    *)
      echo "############### Tool for NixOS System Management ###############"
      echo "Usage ->"
      echo "update        - Updates system Flake inputs"
      echo "apply         - Applies both user and system configuration"
      echo "apply-system  - Applies system configuration"
      echo "apply-user    - Applies user home-manager configuration"
      echo "clean         - Garbage collects and hard links Nix Store"
      echo "list          - Lists all installed packages"
      echo "save          - Saves system configuration state to repository"
    ;;
    esac
  '';
in rec
{
  options.scripts.management = mkOption
  {
    description = "Script for NixOS System Management";
    type = types.bool;
    default = false;
  };
  
  config = mkIf (cfg == true)
  {
    environment.systemPackages = [ script ]; 
  };
}
