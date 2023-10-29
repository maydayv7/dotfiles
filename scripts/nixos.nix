{
  system ? builtins.currentSystem,
  lib,
  inputs,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (inputs) self;
  inherit (util.map) array list;
  inherit (lib) licenses recursiveUpdate util;

  devShells = list self.devShells."${system}";
  installMedia = list self.installMedia;
  nixosConfigurations = list self.nixosConfigurations;

  # Usage Description
  usage = {
    script = ''
      # Legend #
        xxx - Command
        [ ] - Optional                  - Command Description
        ' ' - Variable

      # Usage #
        apply [ --'option' ]            - Applies Device and User Configuration
        cache 'command'                 - Pushes Binary Cache Output to Cachix
        check [ --trace ]               - Checks System Configuration [ Displays Error to Trace ]
        clean [ --all ]                 - Garbage Collects and Optimises Nix Store
        explore                         - Opens Interactive Shell to explore Syntax and Configuration
        install                         - Installs NixOS onto System
        iso 'variant' [ --burn ]        - Builds Image for Specified Install Media or Device [ Burns '.iso' to USB ]
        list [ 'pattern' ]              - Lists all Installed Packages [ Returns Matches ]
        locate 'package'                - Locates Installed Package
        run [ 'path' ] 'command'        - Runs Specified Command [ from 'path' ] (Wraps 'nix run')
        save                            - Saves Configuration State to Repository
        search 'term' [ 'source' ]      - Searches for Packages [ Providing 'term' ] or Configuration Options
        secret 'choice' [ 'path' ]      - Manages 'sops' Encrypted Secrets
        shell [ 'name' ]                - Opens desired Nix Developer Shell
        update [ 'repository' ['rev'] ] - Updates System Repositories
    '';

    apply = ''
      # Usage #
        --activate                  - Activates Current Configuration
        --boot                      - Applies Configuration on boot
        --check                     - Checks Configuration Build
        --rollback [ 'generation' ] - Reverts to Last [ or Specified ] Build Generation
        --test                      - Tests Configuration Build
    '';

    search = ''
      # Usage #
        cmd.'command'               - Searches for Package providing 'command'
        pkgs.'package' [ 'repo' ]   - Searches for Package 'package' [ In Repository ]
        'term'                      - Searches for Packages and Configuration Options and matching 'term'
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
in
  recursiveUpdate {
    meta = {
      description = "System Management Script";
      homepage = files.path.repo;
      license = licenses.mit;
      maintainers = ["maydayv7"];
    };
  } (pkgs.writeShellApplication {
    name = "nixos";
    runtimeInputs = with pkgs;
      [
        cachix
        coreutils
        generators
        git
        gnupg
        gnused
        gparted
        jq
        nixFlakes
        parted
        sops
        tree
        wine.mkwindowsapp-tools
        zfs
      ]
      ++ array (import ../modules/nix/tools.nix) pkgs;

    text = ''
      set +eu
      ${scripts.commands}
      ${scripts.partitions}

      if [[ -n $IN_NIX_SHELL ]]
      then
        warn "You are in a Nix Developer Shell" "'nixos' may not work here properly\n"
      fi

      case $1 in
      "") error "Expected an Option" "${usage.script}";;
      help|--help|-h) echo -e "## Tool for NixOS System Management ##\n${usage.script}";;
      apply)
        case $2 in
        "")
          echo "Applying Configuration..."
          sudo nixos-rebuild switch --flake ${path.system}#
        ;;
        "--activate")
          echo "Activating Configuration..."
          sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
        ;;
        "--boot")
          echo "Applying Configuration..."
          sudo nixos-rebuild boot --flake ${path.system}#
          restart
        ;;
        "--check")
          echo "Checking Configuration..."
          nixos-rebuild dry-activate --flake ${path.system}#
        ;;
        "--test")
          echo "Testing Configuration..."
          sudo nixos-rebuild test --no-build-nix --show-trace --flake ${path.system}#
        ;;
        "--rollback")
          profile="/nix/var/nix/profiles/system"
          case $3 in
          "")
            echo "Applying Rollback..."
            sudo nixos-rebuild switch --rollback
          ;;
          list)
            echo "# System Generations #"
            nixos-rebuild list-generations
          ;;
          *)
            echo "Rolling Back to Generation '$3'..."
            sudo nix-env --switch-generation "$3" -p "$profile" && nixos apply --activate
          ;;
          esac
        ;;
        *) error "Unknown Option '$2'" "${usage.apply}";;
        esac
      ;;
      cache)
        if [ -z "$2" ]
          then
            error "Expected a Build Command"
          else
            echo "Executing Command '" "''${@:2}" "'..."
            cachix authtoken "$(find ${path.system} -name cachix-token.secret -exec sops --config ${sops} -d {} \+)"
            cachix watch-exec ${path.cache} "''${@:2}"
        fi
      ;;
      check)
        echo "Formatting Code..."
        pushd ${path.system} > /dev/null; nix fmt; popd > /dev/null
        case $2 in
        "") nix flake check ${path.system} --keep-going;;
        "--trace") nix flake check ${path.system} --keep-going --show-trace;;
        *) nix flake check "$2" --keep-going;;
        esac
      ;;
      clean)
        echo "Running Garbage Collection..."
        mkwindows-tools-gc
        nix-collect-garbage -d
        rm -rf /nix/var/nix/profiles/per-user/"$USER"/profile
        if [ "$EUID" -ne 0 ] && [ "$2" != "--all" ]
        then
          warn "Run as 'root' or use Option '--all' to Clean System Generations"
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
        "") nix repl --arg host true --arg path ${path.system} --file ${repl};;
        *) nix repl --arg path "$(readlink -f "$2" | sed 's|/flake.nix||')" --file ${repl};;
        esac
      ;;
      install)
        case $2 in
        "--first-boot")
          if [ -d ${persist} ]; then
            DIR=${persist}${path.system}
          else
            DIR=${path.system}
          fi
          git clone --recurse-submodules ${path.repo} "$DIR"
          nixos apply --activate
        ;;
        "")
          internet
          if [ "$EUID" -ne 0 ]
          then
            error "This Command must be Executed as 'root'"
          fi
          read -rp "Enter Name of Device to Install: " HOST
          read -rp "Do you want to Automatically Create the Partitions? (Y/N): " choice
            case $choice in
              [Yy]*) warn "Assuming Disk is Completely Empty"; partition_disk;;
              *) warn "You must Create, Format and Label the Partitions on your own"; gparted > /dev/null;;
            esac
          newline
          read -rp "Select Filesystem to use for Disk (simple/advanced): " choice
            case $choice in
              1|[Ss]*)
                read -rp "Do you want to Create and Format the EXT4 Partitions? (Y/N): " choice
                  case $choice in
                    [Yy]*) DIR=${path.system}; create_ext4; mount_ext4;;
                    *) warn "Assuming that Required EXT4 Partition has already been Created"; mount_ext4;;
                  esac
              ;;
              2|[Aa]*)
                read -rp "Do you want to Create the ZFS Pool and Datasets? (Y/N): " choice
                  case $choice in
                    [Yy]*) DIR=${persist}${path.system}; create_zfs; mount_zfs;;
                    *) warn "Assuming that Required ZFS Pool and Datasets have already been Created"; mount_zfs;;
                  esac
              ;;
              *) error "Choose (1)simple or (2)advanced";;
            esac
          newline
          mount_other
          newline
          read -rp "Enter Path to Repository (path/URL): " URL
          if [ -z "$URL" ]
          then
            URL=${path.flake}
          fi
          echo "Installing System from '$URL'..."
          nixos-install --no-root-passwd --root /mnt --flake "$URL"#"$HOST"
          newline

          read -rp "Enter Path to GPG Keys (path/.git): " KEY
          LINK='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
          if [ -z "$KEY" ]
          then
            error "Path to GPG Keys cannot be empty"
          elif [[ $KEY =~ $LINK ]]
          then
            echo "Cloning Keys..."
            git clone "$KEY" keys --progress
          else
            cp -r "$KEY"/. ./keys
          fi
          echo "Importing Keys..."
          find ./keys -name '*.gpg' -exec gpg --homedir /mnt${files.gpg} --import {} \+
          rm -rf ./keys
          newline

          unmount_all
          newline
          info "Run 'nixos install --first-boot' after rebooting to finish the install"
          restart
        ;;
        esac
      ;;
      iso)
        case $2 in
        "") error "Expected a Variant of Install Media or Device";;
        *)
          if grep -wq "$2" <<<"${installMedia}"
          then
            echo "Building '$2' Install Media Image..."
            nix build ${path.system}#installMedia."$2".config.system.build.isoImage && echo "The Image is located at './result/iso/nixos.iso'"
          elif grep -wq "$2" <<<"${nixosConfigurations}"
          then
            echo "Building '$2' Device Image..."
            nixos-generate -f iso --flake ${path.system}#"$2"
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
          *) sudo dd if=./result/iso/nixos.iso of="$4" status=progress bs=1M;;
          esac
        ;;
        *) error "Unknown Option '$3'";;
        esac
      ;;
      "list")
        case $2 in
        "") nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq;;
        *) find=$(nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq | grep "$2")
        if [ -z "$find" ]
          then
            if nix search nixpkgs#"$2" &> /dev/null
            then
              error "Package '$2' is not installed"
            else
              error "Package '$2' not found"
            fi
          else
            echo "$find"
          fi
        ;;
        esac
      ;;
      "locate")
        case $2 in
        "") error "Expected Package Name";;
        *)
          package=$(nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq | grep "$2")
          if [ -z "$package" ]
          then
            location=$(find /nix/store -maxdepth 1 -type d -name "*$2*")
            if [ -n "$location" ]
            then
              if (( $(grep -c . <<<"$location") > 1 ))
              then
                echo -e "Locations:\n$location"
              else
                echo -e "Location: $location"
              fi
            else
              if nix search nixpkgs#"$2" &> /dev/null
              then
                error "Package '$2' is not installed"
              else
                error "Package '$2' is invalid"
              fi
            fi
          else
            if (( $(grep -c . <<<"$package") > 1 ))
            then
              locations=$(find /nix/store -maxdepth 1 -type d -name "*$2*")
              echo -e "Locations:\n$locations"
            else
              echo "Package $package found"
              nix search nixpkgs#"$2" &> /dev/null && location=$(nix eval nixpkgs#"$2".outPath 2> /dev/null | sed 's/"//g') || location=$(find /nix/store -maxdepth 1 -type d -name "*$package")
              echo "Location: $location"
            fi
          fi
        ;;
        esac
      ;;
      run)
        if [[ "$2" == *[:/]* ]] || grep -wq "$2" <<<"${list inputs + "nixpkgs"}"
        then
          nix run "$2"#"$3" -- "''${@:4}"
        else
          nix run ${path.system}#"$2" -- "''${@:3}"
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
        "") error "Expected an Option" "${usage.search}";;
        help|--help|-h) echo "${usage.search}";;
        cmd.*)
          command="''${2//cmd\./}"
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
          package="''${2//pkgs\./}"
          echo "Searching for Package '$package'..."
          if [ -z "$3" ]
          then
            nix search nixpkgs#"$package"
          else
            nix search "$3"#"$package"
          fi
        ;;
        *)
          echo "Searching for Term '$2'..."
          manix "$2"
        ;;
        esac
      ;;
      secret)
        case $2 in
        "") error "Expected an Option" "${usage.secret}";;
        help|--help|-h) echo "${usage.secret}";;
        create)
          case $3 in
          "") error "Expected 'name' of Secret";;
          *)
            echo "Creating Secret '$3'..."
            sops --config ${sops} -i ${path.system}/"$3".secret
          ;;
          esac
        ;;
        edit)
          case $3 in
          "") error "Expected 'name' of Secret";;
          *)
            echo "Editing Secret '$3'..."
            find ${path.system} -name "$3".secret -exec sops --config ${sops} -i {} \+ || error "Unknown Secret '$3'"
          ;;
          esac
        ;;
        list)
          echo "## Secrets in ${path.system} ##"
          grep / ${sops} | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path.system}/|' | xargs tree -C --noreport -P '*.secret' -I '_*' | sed 's/\.secret//'
        ;;
        show)
          echo "Showing Secret '$3'..."
          find ${path.system} -name "$3".secret -exec sops --config ${sops} -d {} \+ || error "Unknown Secret '$3'"
        ;;
        update)
          echo "Updating Secrets..."
          find ${path.system} -name '*.secret' ! -name '_*' -exec sops --config ${sops} updatekeys {} \;
        ;;
        *) error "Unknown Option '$2'" "${usage.secret}";;
        esac
      ;;
      shell)
        case $2 in
        "") nix develop ${path.system} --command "$SHELL";;
        *)
          if grep -wq "$2" <<<"${devShells}"
          then
            nix develop ${path.system}#"$2" --command "$SHELL"
          else
            error "Unknown Shell '$2'" "# Available Shells #\n  ${devShells}"
          fi
        ;;
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
        "--pkgs")
          echo "Updating Packages..."
          pushd ${path.system}/packages > /dev/null
          bash ${./packages.sh}
          popd > /dev/null
        ;;
        *)
          echo "Updating Flake Input '$2'..."
          if [ -z "$3" ]
          then
            nix flake lock ${path.system} --update-input "$2"
          else
            nix flake lock ${path.system} --override-input "$2" "$3"
          fi
        ;;
        esac
      ;;
      *) error "Unknown Option '$1'" "${usage.script}";;
      esac
    '';
  })
