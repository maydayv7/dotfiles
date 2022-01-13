{ system ? "x86_64-linux", lib, inputs, pkgs, files, ... }:
with pkgs;
with files;
let
  inherit (lib.map) list;
  inherit (inputs) self;

  installMedia = list self.installMedia;
  devShells = list self.devShells."${system}";

  # Usage Description
  usage = {
    script = ''
      ## Tool for NixOS System Management ##
      # Usage #
        apply [ --'option' ]       - Applies Device and User Configuration
        check                      - Checks System Configuration
        clean                      - Garbage Collects and Optimises Nix Store
        explore                    - Opens Interactive Shell to explore Syntax and Configuration
        iso 'variant' [ --burn ]   - Builds Install Media and optionally burns .iso to USB
        list                       - Lists all Installed Packages
        save                       - Saves Configuration State to Repository
        secret 'choice' [ 'path' ] - Manages 'sops' Encrypted Secrets
        shell [ 'name' ]           - Opens desired Nix Developer Shell
        update [ --'option' ]      - Updates System Repositories
    '';

    apply = ''
      # Usage #
        --boot                     - Applies Configuration on boot
        --check                    - Checks Configuration Build
        --rollback                 - Reverts to Last Build Generation
        --test                     - Tests Configuration Build
    '';

    secret = ''
      # Usage #
        edit 'path'                - Edits desired Secret
        list                       - Lists all 'sops' Encrypted Secrets
        show 'path'                - Shows desired Secret
        update 'path'              - Updates Secrets to defined Keys
    '';
  };
in lib.recursiveUpdate {
  meta.description = "System Management Script";
  buildInputs = [ coreutils dd git gnused nixfmt nix-linter sops tree ];
} (writeShellScriptBin "nixos" ''
  #!${runtimeShell}
  ${scripts.commands}

  case $1 in
  "help"|"--help"|"-h") echo "${usage.script}";;
  "apply")
    echo "Applying Configuration..."
    case $2 in
    "") sudo nixos-rebuild switch --flake ${path}#;;
    "--boot") sudo nixos-rebuild boot --flake ${path}#;;
    "--check") nixos-rebuild dry-activate --flake ${path}#;;
    "--rollback") sudo nixos-rebuild switch --rollback;;
    "--test") sudo nixos-rebuild test --flake ${path}#;;
    *) error "Unknown option $2" "${usage.apply}";;
    esac
  ;;
  "check")
    echo "Formatting Code..."
    find ${path} -type f -name "*.nix" | xargs nixfmt
    echo "Checking Syntax..."
    nix flake check ${path} --keep-going
    nix-linter -r ${path} || true
  ;;
  "clean")
    echo "Running Garbage Collection..."
    nix store gc
    nix-collect-garbage -d
    printf "\n"
    echo "Running De-Duplication..."
    nix store optimise
  ;;
  "explore") nix repl ${repl};;
  "iso")
    case $2 in
    "") error "Expected a Variant of Install Media";;
    *)
      echo "Building $2 .iso file..."
      nix build ${path}#installMedia.$2.config.system.build.isoImage && echo "The image is located at ./result/iso/nixos.iso" || error "Unknown Variant $2" "# Available Variants #\n  ${installMedia}"
    ;;
    esac
    case $3 in
    "");;
    "--burn")
      case $4 in
      "") error "Expected a 'path' to USB Drive";;
      *) sudo dd if=./result/iso/nixos.iso of=$4 status=progress bs=1M;;
      esac
    ;;
    *) error "Unknown option $3";;
    esac
  ;;
  "list") nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq;;
  "save")
    echo "Saving Changes..."
    pushd ${path} > /dev/null
    git stash
    git pull --rebase
    git stash pop
    git add .
    git commit
    git push --force
    git push --force --mirror mirror
    popd > /dev/null
  ;;
  "secret")
    case $2 in
    "help"|"--help"|"-h") echo "${usage.secret}";;
    "edit")
      case $3 in
      "") error "Expected 'name' of Secret";;
      *)
        echo "Editing Secret $3..."
        find ${path} -name $3.secret | xargs sops --config ${sops} -i || error "Unknown Secret $3"
      ;;
      esac
    ;;
    "list")
      echo "## Secrets in ${path} ##"
      cat ${sops} | grep / | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path}/|' | xargs tree -C --noreport -P '*.secret' -I '_*' | sed 's/\.secret//'
    ;;
    "show")
      echo "Showing Secret $3..."
      find ${path} -name $3.secret | xargs sops --config ${sops} -d || error "Unknown Secret $3"
    ;;
    "update")
      echo "Updating Secrets..."
      for secret in `find ${path} -name '*.secret' ! -name '_*'`
      do
        sops --config ${sops} updatekeys $secret
      done
    ;;
    *)
      if [ -z "$2" ]
      then
        error "Expected an option" "${usage.secret}"
      else
        error "Unknown option $2" "${usage.secret}"
      fi
    ;;
    esac
  ;;
  "shell")
    case $2 in
    "") nix develop ${path} --command $SHELL;;
    *) nix develop ${path}#$2 --command $SHELL || error "Unknown Shell $2" "# Available Shells #\n  ${devShells}";;
    esac
  ;;
  "update")
    echo "Updating Flake Inputs..."
    nix flake update ${path} $2
  ;;
  *)
    if [ -z "$1" ]
    then
      error "Expected an option" "${usage.script}"
    else
      error "Unknown option $1" "${usage.script}"
    fi
  ;;
  esac
'')
