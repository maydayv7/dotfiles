{ lib, pkgs, path, ... }:
with pkgs;
let
  # Usage Description
  usage =
  {
    script =
    ''
      ## Tool for NixOS System Management ##
      # Usage #
        apply [ --'option' ]            - Applies Device and User Configuration
        check                           - Checks System Configuration
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
        edit 'path'   - Edit desired Secret
        list        - List system Secrets
        show 'path'   - Show desired Secret
        update 'path' - Update Secrets to defined keys
    '';
  };
in
lib.recursiveUpdate
{
  meta.description = "System Management Script";
  buildInputs = [ coreutils dd git gnused sops tree ];
}
(writeShellScriptBin "nixos"
''
  #!${runtimeShell}
  error() { echo -e "\033[0;31merror:\033[0m $1"; exit 125; }

  case $1 in
  "apply")
    echo "Applying Configuration..."
    case $2 in
    "") sudo nixos-rebuild switch --flake ${path.system}#;;
    "--boot") sudo nixos-rebuild boot --flake ${path.system}#;;
    "--check") nixos-rebuild dry-activate --flake ${path.system}#;;
    "--rollback") sudo nixos-rebuild switch --rollback;;
    "--test") sudo nixos-rebuild test --flake ${path.system}#;;
    *) error "Unknown option $2\n${usage.apply}";;
    esac
  ;;
  "check") nix flake check /etc/nixos --keep-going;;
  "clean")
    echo "Running Garbage Collection..."
    nix store gc
    printf "\n"
    echo "Running De-Duplication..."
    nix store optimise
  ;;
  "explore") nix repl ${path.system}/repl.nix;;
  "iso")
    echo "Building $2 ISO file..."
    nix build ${path.system}#installMedia.$2.config.system.build.isoImage && echo "The image is located at ./result/iso/nixos.iso"
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
    pushd ${path.system} > /dev/null
    git add .
    git commit
    git pull --rebase
    git push
    popd > /dev/null
  ;;
  "secret")
    case $2 in
    "edit")
      case $3 in
      "") error "Expected a path to Secret following edit command";;
      *)
        echo "Editing Secret $3..."
        sops --config ${path.system}/.sops.yaml -i $3
      ;;
      esac
    ;;
    "list") cat ${path.system}/.sops.yaml | grep / | sed 's/  - path_regex: //' | sed 's/\/\.\*\$//' | xargs tree -C --noreport -I '*.nix';;
    "show") sops --config ${path.system}/.sops.yaml -d $3;;
    "update")
      echo "Updating Secrets..."
      for secret in $3
      do
        sops --config ${path.system}/.sops.yaml updatekeys $secret
      done
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
    "") nix develop ${path.system} --command $SHELL;;
    *) nix develop ${path.system}#$2 --command $SHELL;;
    esac
  ;;
  "update")
    echo "Updating Flake Inputs..."
    nix flake update ${path.system} $2
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
'')
