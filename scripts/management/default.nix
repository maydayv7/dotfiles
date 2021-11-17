{ config, lib, inputs, pkgs, ... }:
let
  enable = config.scripts.management;

  # Usage Description
  usage =
  {
    script =
    ''
      ## Tool for NixOS System Management ##
      # Usage #
        update [ --'option' ]              - Updates Nix Flake Inputs
        apply  [ 'choice' [ --'option' ] ] - Applies Device and User Configuration
        iso 'variant' [ --burn 'path' ]    - Builds Install Media
        shell [ 'name' ]                   - Opens desired Nix Developer Shell
        list                               - Lists all Installed Packages
        save                               - Saves Configuration State to Repository
        clean                              - Garbage Collects and Hard-Links Nix Store
        secret 'choice' [ 'path' ]         - Manages system Secrets
    '';

    apply =
    ''
      # Usage #
        device [ --'option' ] - Apply Device Configuration
        user                  - Apply User Configuration
    '';

    device =
    ''
      # Usage #
        --boot  - Apply Configuration on boot
        --test  - Test Configuration Build
        --check - Check Configuration Build
    '';

    secret =
    ''
      # Usage #
        list        - List system Secrets
        show 'path' - Show desired Secret
        edit 'path' - Edit desired Secret
    '';
  };

  # System Management Script
  script = with pkgs; writeScriptBin "nixos"
  ''
    #!${pkgs.runtimeShell}
    error()
    {
      echo -e "\033[0;31merror:\033[0m $1"
      exit 125
    }

    case $1 in
    "update")
      echo "Updating Flake Inputs..."
      nix flake update /etc/nixos $2
    ;;
    "apply")
      case $2 in
      "")
        nixos apply device
        printf "\n"
        nixos apply user
      ;;
      "device")
        echo "Applying Device Settings..."
        case $3 in
        "") sudo nixos-rebuild switch --flake /etc/nixos#;;
        "--boot") sudo nixos-rebuild boot --flake /etc/nixos#;;
        "--test") sudo nixos-rebuild test --flake /etc/nixos#;;
        "--check") nixos-rebuild dry-activate --flake /etc/nixos#;;
        *) error "Unknown option $3\n${usage.device}";;
        esac
      ;;
      "user")
        echo "Applying User Settings..."
        nix build /etc/nixos#homeConfigurations.$USER.activationPackage && ./result/activate && rm -rf ./result
      ;;
      *) error "Unknown option $2\n${usage.apply}";;
      esac
    ;;
    "iso")
      echo "Building $2 ISO file..."
      nix build /etc/nixos#installMedia.$2.config.system.build.isoImage && echo "The image is located at ./result/iso/nixos.iso"
      case $3 in
      "") echo "The --burn option can be used to burn the Image to a USB";;
      "--burn")
        case $4 in
        "") error "Expected a path to USB Drive following --burn command";;
        *) sudo dd if=./result/iso/nixos.iso of=$4 status=progress bs=1M;;
        esac
      ;;
      *) error "Unknown option $3";;
      esac
    ;;
    "shell")
      case $2 in
      "") nix develop /etc/nixos;;
      *) nix develop /etc/nixos#$2;;
      esac
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
    "secret")
      case $2 in
      "list") tree -C --noreport ${inputs.secrets};;
      "show") echo "$3:" && cat ${inputs.secrets}/$3;;
      "edit")
        case $3 in
        "") error "Expected a path to Secret following edit command";;
        *)
          echo "Editing Secret $3..."
          git clone https://github.com/maydayv7/secrets secrets.bak && pushd secrets.bak
          nano ./$3
          git add .
          read -p "Enter comment: " comment
          git commit -m "$(echo $comment)"
          git push
          popd && rm -rf secrets.bak
          nix flake lock --update-input secrets /etc/nixos
        ;;
        esac
      ;;
      *)
        if [ -z "$2" ]; then
          echo "${usage.secret}"
        else
          error "Unknown option $2\n${usage.secret}"
        fi
      ;;
      esac
    ;;
    *)
      if [ -z "$1" ]; then
        echo "${usage.script}"
      else
        error "Unknown option $1\n${usage.script}"
      fi
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

  config = lib.mkIf enable
  {
    environment.systemPackages = with pkgs; [ script tree ];
  };
}