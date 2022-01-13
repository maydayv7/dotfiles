{ system ? "x86_64-linux", lib, inputs, pkgs, files, ... }:
with pkgs;
let
  inherit (lib.map) list;
  path = files.path;
  repl = "${path}/shells/repl/repl.nix";
  sops = "${path}/secrets/.sops.yaml";

  # Usage Description
  usage =
  {
    script =
    ''
      ## Tool for NixOS System Management ##
      # Usage #
        apply [ --'option' ]       - Applies Device and User Configuration
        check                      - Checks System Configuration
        clean                      - Garbage Collects and Hard-Links Nix Store
        explore                    - Opens interactive shell to explore syntax and configuration
        iso 'variant' [ --burn ]   - Builds Install Media and optionally burns .iso to USB
        list                       - Lists all Installed Packages
        save                       - Saves Configuration State to Repository
        secret 'choice' [ 'path' ] - Manages system Secrets
        shell [ 'name' ]           - Opens desired Nix Developer Shell
        update [ --'option' ]      - Updates Nix Flake Inputs
    '';

    apply =
    ''
      # Usage #
        --boot                     - Apply Configuration on boot
        --check                    - Check Configuration Build
        --rollback                 - Revert to last Build Generation
        --test                     - Test Configuration Build
    '';

    secret =
    ''
      # Usage #
        edit 'path'                - Edit desired Secret
        list                       - List system Secrets
        show 'path'                - Show desired Secret
        update 'path'              - Update Secrets to defined keys
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
  error() { echo -e "\033[0;31merror:\033[0m $1"; exit 7; }

  case $1 in
  "apply")
    echo "Applying Configuration..."
    case $2 in
    "") sudo nixos-rebuild switch --flake ${path}#;;
    "--boot") sudo nixos-rebuild boot --flake ${path}#;;
    "--check") nixos-rebuild dry-activate --flake ${path}#;;
    "--rollback") sudo nixos-rebuild switch --rollback;;
    "--test") sudo nixos-rebuild test --flake ${path}#;;
    *) error "Unknown option $2\n${usage.apply}";;
    esac
  ;;
  "check") nix flake check /etc/nixos --keep-going;;
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
    "") error "Expected a Variant of Install Media following 'iso' command";;
    *)
      echo "Building $2 .iso file..."
      nix build ${path}#installMedia.$2.config.system.build.isoImage && echo "The image is located at ./result/iso/nixos.iso" || echo -e "\nAvailable Variants: \n${list inputs.self.installMedia}"
    ;;
    esac
    case $3 in
    "");;
    "--burn")
      case $4 in
      "") error "Expected a path to USB Drive following --burn command";;
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
    "edit")
      case $3 in
      "") error "Expected a path to Secret following 'edit' command";;
      *)
        echo "Editing Secret $3..."
        sops --config ${sops} -i $3
      ;;
      esac
    ;;
    "list") cat ${sops} | grep / | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path}/|' | xargs tree -C --noreport -I '*.nix' -I '_*';;
    "show") sops --config ${sops} -d $3;;
    "update")
      echo "Updating Secrets..."
      for secret in $3
      do
        sops --config ${sops} updatekeys $secret
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
    "") nix develop ${path} --command $SHELL;;
    *) nix develop ${path}#$2 --command $SHELL || echo -e "\nAvailable Shells:\n${list inputs.self.devShells."${system}"}";;
    esac
  ;;
  "update")
    echo "Updating Flake Inputs..."
    nix flake update ${path} $2
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
