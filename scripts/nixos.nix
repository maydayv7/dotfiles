{ system ? builtins.currentSystem, lib, inputs, pkgs, files, ... }:
with files;
let
  inherit (lib.util.map) list;
  inherit (inputs) self;

  devShells = list self.devShells."${system}";
  installMedia = list self.installMedia;
  nixosConfigurations = list self.nixosConfigurations;

  # Usage Description
  usage = {
    script = ''
      # Legend #
        xxx - Command
        [ ] - Optional             - Command Description
        ' ' - Variable

      # Usage #
        apply [ --'option' ]       - Applies Device and User Configuration
        cache 'command'            - Pushes Binary Cache Output to Cachix
        check [ --trace ]          - Checks System Configuration [ Displays Error to Trace ]
        clean [ --all ]            - Garbage Collects and Optimises Nix Store
        explore                    - Opens Interactive Shell to explore Syntax and Configuration
        install                    - Installs NixOS onto System
        iso 'variant' [ --burn ]   - Builds Image for Specified Install Media or Device [ Burns '.iso' to USB ]
        list [ 'pattern' ]         - Lists all Installed Packages [ Returns Matches ]
        locate 'package'           - Locates Installed Package
        run [ 'path' ] 'command'   - Runs Specified Command [ from 'path' ] (Wraps 'nix run')
        save                       - Saves Configuration State to Repository
        search 'term' [ 'source' ] - Searches for Packages [ Providing 'term' ] or Configuration Options
        secret 'choice' [ 'path' ] - Manages 'sops' Encrypted Secrets
        setup                      - Sets up System after Install
        shell [ 'name' ]           - Opens desired Nix Developer Shell
        update [ 'repository' ]    - Updates System Repositories
    '';

    apply = ''
      # Usage #
        --boot                     - Applies Configuration on boot
        --check                    - Checks Configuration Build
        --deploy [ 'device' ]      - Automatically Deploy via SSH
        --rollback                 - Reverts to Last Build Generation
        --test                     - Tests Configuration Build
    '';

    search = ''
      # Usage #
        cmd.'command'              - Searches for Package providing 'command'
        pkgs.'package' [ 'repo' ]  - Searches for Package 'package' [ In Repository ]
        'term'                     - Searches for Packages and Configuration Options and matching 'term'
    '';

    secret = ''
      # Usage #
        create 'path'              - Creates desired Secret
        edit 'name'                - Edits desired Secret
        list                       - Lists all 'sops' Encrypted Secrets
        show 'name'                - Shows desired Secret
        update                     - Updates Secrets to defined Keys
    '';
  };
in lib.recursiveUpdate {
  meta.description = "System Management Script";
  buildInputs = with pkgs; [
    cachix
    coreutils
    dd
    git
    git-crypt
    gparted
    gnused
    manix
    nixfmt
    nix-linter
    nixos-generators
    parted
    sops
    tree
    zfs
    inputs.deploy.defaultPackage."${system}"
  ];
} (pkgs.writeShellScriptBin "nixos" ''
  #!${pkgs.runtimeShell}
  set -o pipefail

  ${scripts.commands}
  ${scripts.partitions}

  case $1 in
  "") error "Expected an option" "${usage.script}";;
  help|--help|-h) echo -e "## Tool for NixOS System Management ##\n${usage.script}";;
  apply)
    echo "Applying Configuration..."
    case $2 in
    "") sudo nixos-rebuild switch --flake ${path.system}#;;
    "--boot") sudo nixos-rebuild boot --flake ${path.system}#;;
    "--check") nixos-rebuild dry-activate --flake ${path.system}#;;
    "--deploy") deploy -s ${path.system}#$3;;
    "--rollback") sudo nixos-rebuild switch --rollback;;
    "--test") sudo nixos-rebuild test --no-build-nix --show-trace --flake ${path.system}#;;
    *) error "Unknown option '$2'" "${usage.apply}";;
    esac
  ;;
  cache)
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
  check)
    if [ "$2" == "--trace" ]
    then
      flags="--show-trace"
    fi
    echo "Formatting Code..."
    find ${path.system} -type f -name "*.nix" -exec nixfmt {} \+
    echo "Checking Syntax..."
    nix-linter -r ${path.system} || true
    nix flake check ${path.system} --keep-going $flags
  ;;
  clean)
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
  explore)
    case $2 in
    "") nix repl --arg host true --arg path ${path.system} ${repl};;
    *) nix repl --arg path $(readlink -f $2 | sed 's|/flake.nix||') ${repl};;
    esac
  ;;
  install)
    internet
    if [ "$EUID" -ne 0 ]
    then
      error "This Command must be Executed as 'root'"
    fi
    read -p "Enter Name of Device to Install: " HOST
    read -p "Do you want to Automatically Create the Partitions? (Y/N): " choice
      case $choice in
        [Yy]*) warn "Assuming Disk is Completely Empty"; partition_disk;;
        *) warn "You must Create, Format and Label the Partitions on your own"; gparted > /dev/null;;
      esac
    newline
    read -p "Select Filesystem to use for Disk (simple/advanced): " choice
      case $choice in
        1|[Ss]*)
          read -p "Do you want to Create ZFS Pool and Datasets? (Y/N): " choice
            case $choice in
              [Yy]*) create_ext4; mount_ext4;;
              *) warn "Assuming that Required EXT4 Partition has already been Created"; mount_ext4;;
            esac
        ;;
        2|[Aa]*)
          read -p "Do you want to Create ZFS Pool and Datasets? (Y/N): " choice
            case $choice in
              [Yy]*) create_zfs; mount_zfs;;
              *) warn "Assuming that Required ZFS Pool and Datasets have already been Created"; mount_zfs;;
            esac
        ;;
        *) error "Choose (1)simple or (2)advanced";;
      esac
    newline
    mount_other
    newline
    read -p "Enter Path to Repository (path/URL): " URL
    if [ -z "$URL" ]
    then
      URL=${path.flake}
    fi
    echo "Installing System from '$URL'..."
    nixos-install --no-root-passwd --root /mnt --flake $URL#$HOST --impure
    warn "Run 'nixos setup' in the Newly Installed System to Finish Setup"
    unmount_all
    newline
    restart
  ;;
  iso)
    case $2 in
    "") error "Expected a Variant of Install Media or Device";;
    *)
      if grep -wq $2 <<<"${installMedia}"
      then
        echo "Building '$2' Install Media Image..."
        nix build ${path.system}#installMedia.$2.config.system.build.isoImage && echo "The Image is located at './result/iso/nixos.iso'"
      elif grep -wq $2 <<<"${nixosConfigurations}"
      then
        echo "Building '$2' Device Image..."
        nix run github:nix-community/nixos-generators -- -f iso --flake ${path.system}#$2
      else
        error "Unknown Variant '$2'" "# Available Variants #\n  Install Media: ${installMedia}\n  Devices: ${nixosConfigurations}"
      fi
    ;;
    esac
    case $3 in
    "") echo "The '--burn' Option can be used to Flash the Image onto a USB";;
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
    *) nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq | grep $2;;
    esac
  ;;
  "locate")
    case $2 in
    "") error "Expected Package Name";;
    *)
      package=$(nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq | grep $2)
      if [ -z "$package" ]
      then
        nix search nixpkgs#$2 &> /dev/null && error "Package '$2' is not installed" || error "Package '$2' is invalid"
      else
        if (( $(grep -c . <<<"$package") > 1 ))
        then
          locations=$(find /nix/store -maxdepth 1 -type d -name "*$2*")
          echo -e "Locations:\n$locations"
        else
          echo "Package $package found"
          nix search nixpkgs#$2 &> /dev/null && location=$(nix eval nixpkgs#$2.outPath 2> /dev/null | sed 's/"//g') || location=$(find /nix/store -maxdepth 1 -type d -name "*$package")
          echo "Location: $location"
        fi
      fi
    ;;
    esac
  ;;
  run)
    if [[ "$2" == *[:/]* ]]
    then
      command=$(echo "''${@:4}")
      nix run $2#$3 -- $command
    else
      command=$(echo "''${@:3}")
      nix run ${path.system}#$2 -- $command
    fi
  ;;
  save)
    echo "Saving Changes..."
    pushd ${path.system} > /dev/null
    git stash
    git pull --rebase
    git stash pop
    git add .
    git commit
    git push --force
    popd > /dev/null
  ;;
  search)
    case $2 in
    "") error "Expected an option" "${usage.search}";;
    help|--help|-h) echo "${usage.search}";;
    cmd.*)
      command=$(echo $2 | sed 's/cmd\.//')
      echo "Searching for Package providing Command '$command'..."
      output=$(nix-locate --whole-name --type x --type s --no-group --top-level --at-root "/bin/$command")
      if [ -z "$output" ]
      then
        error "Command '$command' not found"
      else
        echo "$output"
      fi
    ;;
    pkgs.*)
      package=$(echo $2 | sed 's/pkgs\.//')
      echo "Searching for Package '$package'..."
      if [ -z "$3" ]
      then
        nix search nixpkgs#$package
      else
        nix search $3#$package
      fi
    ;;
    *)
      echo "Searching for Term '$2'..."
      manix $2;;
    esac
  ;;
  secret)
    case $2 in
    "") error "Expected an option" "${usage.secret}";;
    help|--help|-h) echo "${usage.secret}";;
    create)
      case $3 in
      "") error "Expected 'name' of Secret";;
      *)
        echo "Creating Secret $3..."
        sops --config ${sops} -i ${path.system}/$3.secret
      ;;
      esac
    ;;
    edit)
      case $3 in
      "") error "Expected 'name' of Secret";;
      *)
        echo "Editing Secret $3..."
        find ${path.system} -name $3.secret | xargs sops --config ${sops} -i || error "Unknown Secret '$3'"
      ;;
      esac
    ;;
    list)
      echo "## Secrets in ${path.system} ##"
      cat ${sops} | grep / | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path.system}/|' | xargs tree -C --noreport -P '*.secret' -I '_*' | sed 's/\.secret//'
    ;;
    show)
      echo "Showing Secret '$3'..."
      find ${path.system} -name $3.secret | xargs sops --config ${sops} -d || error "Unknown Secret '$3'"
    ;;
    update)
      echo "Updating Secrets..."
      for secret in `find ${path.system} -name '*.secret' ! -name '_*'`
      do
        sops --config ${sops} updatekeys $secret
      done
    ;;
    *) error "Unknown option '$2'" "${usage.secret}";;
    esac
  ;;
  setup)
    internet
    keys
    newline
    echo "Preparing Directory..."
    if ! [ -d /persist ]
    then
      DIR=${path.system}
    else
      DIR=/persist${path.system}
    fi
    su recovery -c 'if ! [ -d /persist ]; then DIR=${path.system}; else DIR=/persist${path.system}; fi; sudo -S rm -rf $DIR && sudo mkdir $DIR && sudo chgrp -R keys $DIR && sudo chmod g+rwx $DIR'
    newline
    echo "Cloning Repository..."
    git clone ${path.repo} $DIR
    cd $DIR
    git-crypt unlock
    newline
    echo "Applying Configuration..."
    if [ -d /persist ]
    then
      su recovery -c 'sudo -S umount -l ${path.system} && sudo -S mount ${path.system}'
    fi
    su recovery -c 'sudo -S nixos-rebuild switch --flake ${path.system}'
    restart
  ;;
  shell)
    case $2 in
    "") nix develop ${path.system} --command $SHELL;;
    *) nix develop ${path.system}#$2 --command $SHELL || error "Unknown Shell '$2'" "# Available Shells #\n  ${devShells}";;
    esac
  ;;
  update)
    case $2 in
    "")
      echo "Updating Flake Inputs..."
      nix flake update ${path.system}
    ;;
    "--commit")
      echo "Updating Flake Inputs..."
      nix flake update ${path.system} --commit-lock-file
    ;;
    *)
      echo "Updating Flake Input $2..."
      if [ -z "$3" ]
      then
        nix flake lock ${path.system} --update-input $2
      else
        nix flake lock ${path.system} --override-input $2 $3
      fi
    ;;
    esac
  ;;
  *) error "Unknown option '$1'" "${usage.script}";;
  esac
'')
