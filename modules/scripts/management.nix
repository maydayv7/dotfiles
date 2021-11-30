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
        apply [ --'option' ]            - Applies Device and User Configuration
        clean                           - Garbage Collects and Hard-Links Nix Store
        explore                         - Opens interactive shell to explore syntax and configuration
        iso 'variant' [ --burn 'path' ] - Builds Install Media
        list                            - Lists all Installed Packages
        save                            - Saves Configuration State to Repository
        secret 'choice' [ 'path' ]      - Manages system Secrets
        shell [ 'name' ]                - Opens desired Nix Developer Shell
        update [ --'option' ]           - Updates Nix Flake Inputs
    '';

    apply =
    ''
      # Usage #
        --boot     - Apply Configuration on boot
        --check    - Check Configuration Build
        --rollback - Revert to last Build Generation
        --test     - Test Configuration Build
    '';

    secret =
    ''
      # Usage #
        edit 'path' - Edit desired Secret
        list        - List system Secrets
        show 'path' - Show desired Secret
        update      - Update Secrets to defined keys
    '';
  };

  # System Management Script
  script = with pkgs; writeScriptBin "nixos"
  ''
    #!${pkgs.runtimeShell}
    error() { echo -e "\033[0;31merror:\033[0m $1"; exit 125; }
    pushd () { command pushd "$@" > /dev/null; }
    popd () { command popd "$@" > /dev/null; }

    case $1 in
    "apply")
      echo "Applying Configuration..."
      case $2 in
      "") sudo nixos-rebuild switch --flake /etc/nixos#;;
      "--boot") sudo nixos-rebuild boot --flake /etc/nixos#;;
      "--check") nixos-rebuild dry-activate --flake /etc/nixos#;;
      "--rollback") sudo nixos-rebuild switch --rollback;;
      "--test") sudo nixos-rebuild test --flake /etc/nixos#;;
      *) error "Unknown option $2\n${usage.apply}";;
      esac
    ;;
    "clean")
      echo "Running Garbage Collection..."
      nix store gc
      printf "\n"
      echo "Running De-Duplication..."
      nix store optimise
    ;;
    "explore") nix repl /etc/nixos/shells/repl/repl.nix;;
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
    "list")
      nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq
    ;;
    "save")
      echo "Saving Changes..."
      pushd /etc/nixos
      git add .
      git commit
      git pull --rebase
      git push
      popd
    ;;
    "secret")
      case $2 in
      "edit")
        case $3 in
        "") error "Expected a path to Secret following edit command";;
        *)
          echo "Editing Secret $3..."
          pushd /etc/nixos/modules/secrets/encrypted
          if ! grep -Fq "$3" secrets.nix
          then
            read -p "Do you want to add an entry for the new Secret in secrets.nix? (Y/N): " choice
              case $choice in
                [Yy]*) $EDITOR secrets.nix;;
                *) exit;;
              esac
          fi
          agenix -e $3.age -i /etc/ssh/ssh_key
          popd
        ;;
        esac
      ;;
      "list") tree -C --noreport -I secrets.nix /etc/nixos/modules/secrets/encrypted | sed -e 's/\.age$//';;
      "show") sudo cat /run/agenix/$3;;
      "update")
        echo "Updating Secrets..."
        pushd /etc/nixos/modules/secrets/encrypted
        sudo agenix -r -i /etc/ssh/ssh_key
        popd
      ;;
      *)
        if [ -z "$2" ]
        then
          echo "${usage.secret}"
        else
          error "Unknown option $2\n${usage.secret}"
        fi
      ;;
      esac
    ;;
    "shell")
      case $2 in
      "") nix develop /etc/nixos --command $SHELL;;
      *) nix develop /etc/nixos#$2 --command $SHELL;;
      esac
    ;;
    "update")
      echo "Updating Flake Inputs..."
      nix flake update /etc/nixos $2
    ;;
    *)
      if [ -z "$1" ]
      then
        echo "${usage.script}"
      else
        error "Unknown option $1\n${usage.script}"
      fi
    ;;
    esac
  '';
in rec
{
  options.scripts.management = lib.mkEnableOption "Script for NixOS System Management";

  config = lib.mkIf enable
  {
    environment.systemPackages = with pkgs; [ bash script tree nano ];
  };
}
