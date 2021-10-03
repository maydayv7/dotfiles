{ pkgs,  ... }:
let
  runtimeShell = pkgs.runtimeShell;
in
{
  management = pkgs.writeScriptBin "nixos"
  ''
    #!${runtimeShell}
    function applyUser()
    {
      echo "--------------------------------------------------------------------------------"
      echo " Applying User Settings... "
      
      nix build /etc/nixos#homeManagerConfigurations.$USER.activationPackage
      ./result/activate
      rm -rf ./result
      echo "--------------------------------------------------------------------------------"
    }
    
    function applySystem()
    {
      sudo -v
      echo "--------------------------------------------------------------------------------"
      echo " Applying Machine Settings... "
      
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
      echo "--------------------------------------------------------------------------------"
    }
    
    if [ -n "$INNIXSHELLHOME" ]; then
      echo "You are in a nix shell that redirected home!"
      echo "SYS will not work from here properly."
      exit 1
    fi
    
    case $1 in
    "clean")
      echo "Running Garbage collection..."
      nix-store --gc
      echo "Deduplication running (This may take awhile)..."
      nix-store --optimise
    ;;
    "update")
      echo "Updating Flake inputs..."
      nix flake update /etc/nixos
    ;;
    "apply")
      applySystem
      applyUser
    ;;
    "apply-system")
      applySystem
    ;;
    "apply-user")
      applyUser
   ;;
    "list")
      nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq
    ;;
    *)
      echo "Tool for Nix Operating System Management"
      echo ""
      echo "Usage:"
      echo "update        - Updates system Flake inputs"
      echo "apply         - Applies both user and system configuration"
      echo "apply-system  - Applies system configuration"
      echo "apply-user    - Applies user home-manager configuration"
      echo "clean         - Garbage collects and hard links Nix Store"
      echo "list          - Lists all installed packages"
    ;;
    esac
  '';
}
