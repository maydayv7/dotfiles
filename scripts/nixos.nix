{ system ? builtins.currentSystem, lib, inputs, pkgs, files, ... }:
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
        cache 'command'            - Pushes Binary Cache Output to Cachix
        check                      - Checks System Configuration
        clean [ --all ]            - Garbage Collects and Optimises Nix Store
        explore                    - Opens Interactive Shell to explore Syntax and Configuration
        iso 'variant' [ --burn ]   - Builds Install Media and optionally burns '.iso' to USB
        list [ 'package' ]         - Lists all Installed Packages and optionally Locates one
        save                       - Saves Configuration State to Repository
        search 'package'           - Searches for Packages in 'nixpkgs' Repository
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
  buildInputs = [ cachix coreutils dd git gnused nixfmt nix-linter sops tree ];
} (writeShellScriptBin "nixos" ''
  #!${runtimeShell}
  set -o pipefail
  ${commands}

  case $1 in
  "help"|"--help"|"-h") echo "${usage.script}";;
  "apply")
    echo "Applying Configuration..."
    case $2 in
    "") sudo nixos-rebuild switch --flake ${path.system}#;;
    "--boot") sudo nixos-rebuild boot --flake ${path.system}#;;
    "--check") nixos-rebuild dry-activate --flake ${path.system}#;;
    "--rollback") sudo nixos-rebuild switch --rollback;;
    "--test") sudo nixos-rebuild test --no-build-nix --show-trace --flake ${path.system}#;;
    *) error "Unknown option '$2'" "${usage.apply}";;
    esac
  ;;
  "cache")
  command=$(echo "''${@:2}")
    if [ -z "$2" ]
      then
        error "Expected a Build Command"
      else
        echo "Executing Command '$command'..."
        cachix authtoken $(find ${path.system} -name cachix-token.secret | xargs sops --config ${sops} -d)
        cachix watch-exec ${path.cache} $command
    fi
  ;;
  "check")
    echo "Formatting Code..."
    find ${path.system} -type f -name "*.nix" | xargs nixfmt
    echo "Checking Syntax..."
    nix flake check ${path.system} --keep-going
    nix-linter -r ${path.system} || true
  ;;
  "clean")
    echo "Running Garbage Collection..."
    if [ "$EUID" -ne 0 ] && [ "$2" != "--all" ]
    then
      nix-collect-garbage -d
      warn "Run as 'root' or use option '--all' to Clean System Generations"
    else
      sudo nix-collect-garbage -d
      sudo rm -rf /run/secrets/*
      sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
      sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    fi
    newline
    echo "Running De-Duplication..."
    nix store optimise
  ;;
  "explore")
    case $2 in
    "") nix repl --arg path ${path.system} ${repl};;
    *) nix repl --arg path $(readlink -f $2 | sed 's|/flake.nix||') ${repl};;
    esac
  ;;
  "iso")
    case $2 in
    "") error "Expected a Variant of Install Media";;
    *)
      echo "Building '$2' Install Media Image..."
      nix build ${path.system}#installMedia.$2.config.system.build.isoImage && echo "The Image is located at './result/iso/nixos.iso'" || error "Unknown Variant '$2'" "# Available Variants #\n  ${installMedia}"
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
    *) error "Unknown option '$3'";;
    esac
  ;;
  "list")
    case $2 in
    "") nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq;;
    *)
      package=$(nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq | grep $2)
      if [ -z "$package" ]
      then
        nix search nixpkgs#$2 &> /dev/null && error "Package '$2' is not installed" || error "Package '$2' is not valid"
      else
        echo "Package $package found"
        nix search nixpkgs#$2 &> /dev/null && location=$(nix eval nixpkgs#$2.outPath | sed 's/"//g') || location=$(find /nix/store -type d -name "*$package")
        if ! (( $(grep -c . <<<"$MULTILINE") > 1 ))
        then
          echo "Location: $location"
        else
          echo -e "Locations:\n$location"
        fi
      fi
    ;;
    esac
  ;;
  "save")
    echo "Saving Changes..."
    pushd ${path.system} > /dev/null
    git stash
    git pull --rebase
    git stash pop
    git add .
    git commit
    git push --force
    git push --force --mirror mirror
    popd > /dev/null
  ;;
  "search")
    echo "Searching for Package '$2'..."
    nix search nixpkgs#$2
  ;;
  "secret")
    case $2 in
    "help"|"--help"|"-h") echo "${usage.secret}";;
    "edit")
      case $3 in
      "") error "Expected 'name' of Secret";;
      *)
        echo "Editing Secret $3..."
        find ${path.system} -name $3.secret | xargs sops --config ${sops} -i || error "Unknown Secret '$3'"
      ;;
      esac
    ;;
    "list")
      echo "## Secrets in ${path.system} ##"
      cat ${sops} | grep / | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path.system}/|' | xargs tree -C --noreport -P '*.secret' -I '_*' | sed 's/\.secret//'
    ;;
    "show")
      echo "Showing Secret '$3'..."
      find ${path.system} -name $3.secret | xargs sops --config ${sops} -d || error "Unknown Secret '$3'"
    ;;
    "update")
      echo "Updating Secrets..."
      for secret in `find ${path.system} -name '*.secret' ! -name '_*'`
      do
        sops --config ${sops} updatekeys $secret
      done
    ;;
    *)
      if [ -z "$2" ]
      then
        error "Expected an option" "${usage.secret}"
      else
        error "Unknown option '$2'" "${usage.secret}"
      fi
    ;;
    esac
  ;;
  "shell")
    case $2 in
    "") nix develop ${path.system} --command $SHELL;;
    *) nix develop ${path.system}#$2 --command $SHELL || error "Unknown Shell '$2'" "# Available Shells #\n  ${devShells}";;
    esac
  ;;
  "update")
    echo "Updating Flake Inputs..."
    nix flake update ${path.system} $2
  ;;
  *)
    if [ -z "$1" ]
    then
      error "Expected an option" "${usage.script}"
    else
      error "Unknown option '$1'" "${usage.script}"
    fi
  ;;
  esac
'')
