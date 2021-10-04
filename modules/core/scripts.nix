{ pkgs,  ... }:
let
  runtimeShell = pkgs.runtimeShell;
in
{
  management = pkgs.writeScriptBin "nixos"
  ''
    #!${runtimeShell}
    
    if [ -n "$INNIXSHELLHOME" ]; then
      echo "You are in a Nix Shell that redirected ~"
      echo "The tool cannot work here properly"
      exit 1
    fi
    
    function applyUser()
    {
      echo "Applying User Settings..."
      nix build /etc/nixos#homeManagerConfigurations.$USER.activationPackage
      ./result/activate
      rm -rf ./result
    }
    
    function applySystem()
    {
      echo "Applying Machine Settings..."
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
    }
    
    function saveState()
    {
      echo "Saving changes"
      pushd /etc/nixos
      git add .
      read -p "Enter comment: " comment
      git commit -m "$(echo $comment)"
      git pull --rebase
      git push
      popd
    }
    
    case $1 in
    "clean")
      echo "Running Garbage collection..."
      nix-store --gc
      echo "De-duplication running (This may take a while)..."
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
    "save")
      saveState
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
      echo "save          - Saves system configuration state to repository"
    ;;
    esac
  '';
}
