{
  lib,
  inputs,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (inputs) self;
  inherit (lib) licenses recursiveUpdate;

  # Joins an attrset's names into a space-separated string (for shell `grep -wq`)
  list = attrs: builtins.foldl' (x: y: x + y + " ") "" (builtins.attrNames attrs);

  devShells = list self.devShells."${pkgs.stdenv.system}";
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
        iso 'variant' [ --burn ]        - Builds Image for Specified Device [ Burns '.iso' to USB ]
        list [ 'pattern' ]              - Lists all Installed Packages [ Returns Matches ]
        locate 'package'                - Locates Installed Package
        run [ 'path' ] 'command'        - Runs Specified Command [ from 'path' ] (Wraps 'nix run')
        search 'term' [ 'source' ]      - Searches for Packages [ Providing 'term' ] or Configuration Options
        secret 'choice' [ 'path' ]      - Manages 'sops' Encrypted Secrets
        setup                           - Sets up NixOS System (on First Boot)
        shell [ 'name' ]                - Opens desired Nix Developer Shell
        update [ 'repo' / --'option' ]  - Manages System Package Updates
    '';

    apply = ''
      # Usage #
        'specialisation'             - Activates Specified System Specialisation
        --activate [ home ]          - Activates Current [ Home ] Configuration
        --boot                       - Applies Configuration on boot
        --delta                      - Shows Package Delta for Build
        --rollback [ 'generation' ]  - Reverts to Last [ or Specified ] Build Generation
        --test                       - Tests Configuration Build
    '';

    search = ''
      # Usage #
        cmd.'command'              - Searches for Package providing 'command'
        pkgs.'package' [ 'repo' ]  - Searches for Package 'package' [ In Repository ]
        'term'                     - Searches for Packages and Configuration Options and matching 'term'
    '';

    secret = ''
      # Usage #
        create 'path'  - Creates desired Secret
        edit 'name'    - Edits desired Secret
        list           - Lists all 'sops' Encrypted Secrets
        show 'name'    - Shows desired Secret
        update         - Updates Secrets to defined Keys
    '';

    update = ''
      # Usage #
        --pkgs               - Automatically updates manually packaged apps
        --commit             - Updates 'inputs' and commits changes
        'repo' [ 'source' ]  - Updates 'repo' input [ To specified 'source' ]
    '';
  };
in
  recursiveUpdate
  {
    meta = {
      mainProgram = "nixos";
      description = "System Management Script";
      homepage = path.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
  (
    pkgs.writeShellApplication {
      name = "nixos";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        gnused
        git
        jq
        tree
        gnupg
        sops
        wine.mkwindowsapp-tools

        nixFlakes
        cachix
        manix
        dix
        nix-output-monitor
      ];

      text = ''
        set +eu
        ${scripts.commands}

        installed() { nix-store -q -R /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq; }

        missing() {
          if nix search nixpkgs#"$1" &> /dev/null
          then error "Package '$1' is not installed"
          else error "$2"
          fi
        }

        secret_exists() { find ${path.system} -name "$1".secret | grep "secret" &> /dev/null; }

        if [[ -n $IN_NIX_SHELL ]]
        then
          warn "You are in a Nix Developer Shell" "This script may not work here properly\n"
        fi

        case $1 in
        "") error "Expected an Option" "${usage.script}";;
        help|--help|-h) echo -e "## Tool for NixOS System Management ##\n${usage.script}";;
        "apply")
          case $2 in
          help|--help|-h) echo "${usage.apply}";;
          "")
            if [ -z "$NIXOS_SPECIALISATION" ]
            then
              echo "Applying Configuration..."
              sudo nixos-rebuild switch --flake ${path.system}#
            else
              echo "Applying Configuration ($NIXOS_SPECIALISATION)..."
              sudo nixos-rebuild switch --specialisation "$NIXOS_SPECIALISATION"
            fi
          ;;
          "--activate")
            case $3 in
            "")
              if [ -z "$NIXOS_SPECIALISATION" ]
              then
                echo "Activating Configuration..."
                sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
              else
                echo "Activating Configuration ($NIXOS_SPECIALISATION)..."
                sudo /nix/var/nix/profiles/system/specialisation/"$NIXOS_SPECIALISATION"/bin/switch-to-configuration switch
              fi
            ;;
            "home")
              echo "Applying Home Configuration..."
              sudo systemctl restart home-manager-"$USER"
            ;;
            *) error "Unknown Option '$3'";;
            esac
          ;;
          "--boot")
            echo "Applying Configuration..."
            if sudo nixos-rebuild boot --flake ${path.system}#
            then
              restart
            else
              error "Couldn't build generation successfully"
            fi
          ;;
          "--delta")
            echo "Building Configuration..."
            temp nixos_build 2
            HOSTNAME=$(cat /etc/hostname)
            if nom build ${path.system}#nixosConfigurations."$HOSTNAME".config.system.build.toplevel --out-link "$TEMP"
            then
              echo "Processing Delta..."
              dix /run/current-system "$TEMP"
              read -rp "Do you want to apply the configuration? (Y/*): " choice
              case $choice in
                [Yy]*)
                  echo "Applying Configuration..."
                  sudo "$TEMP"/bin/switch-to-configuration switch
                ;;
                *) exit;;
              esac
            else
              error "Couldn't build generation successfully"
            fi
          ;;
          "--test")
            echo "Testing Configuration..."
            sudo nixos-rebuild test --no-build-nix --show-trace --flake ${path.system}#
          ;;
          "--rollback")
            case $3 in
            "")
              echo "Applying Rollback..."
              sudo nixos-rebuild switch --rollback
            ;;
            "list")
              echo "# System Generations #"
              nixos-rebuild list-generations
            ;;
            *)
              echo "Rolling Back to Generation '$3'..."
              sudo nix-env --switch-generation "$3" -p "/nix/var/nix/profiles/system" && nixos apply --activate
            ;;
            esac
          ;;
          *)
            SPECIALISATIONS=$(ls -1 /nix/var/nix/profiles/system/specialisation)
            if grep -wq "$2" <<<"$SPECIALISATIONS" &> /dev/null
            then
              echo "Applying Configuration ($2)..."
              sudo nixos-rebuild switch --specialisation "$2"
            else
              error "Unknown Option '$2'\n${usage.apply}" "# Available Specialisations #\n$SPECIALISATIONS"
            fi
          ;;
          esac
        ;;
        "cache")
          if [ -z "$2" ]
            then
              error "Expected a Build Command"
            else
              echo "Executing Command '" "''${@:2}" "'..."
              cachix authtoken "$(find ${path.system} -name cachix-token.secret -exec sops --config ${path.sops} -d {} \+)"
              cachix watch-exec ${path.cache} "''${@:2}"
          fi
        ;;
        "check")
          echo "Formatting Code..."
          pushd ${path.system} &> /dev/null; nix fmt; popd &> /dev/null
          case $2 in
          "") nix flake check ${path.system} --keep-going;;
          "--trace") nix flake check ${path.system} --keep-going --show-trace;;
          *) nix flake check "$2" --keep-going;;
          esac
        ;;
        "clean")
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
            nixos apply --activate
          fi
          newline
          echo "Running De-Duplication..."
          nix store optimise
        ;;
        "explore")
          case $2 in
          "") nix repl --arg host true --arg path ${path.system} --file ${repl};;
          *) nix repl --arg path "$(readlink -f "$2" | sed 's|/flake.nix||')" --file ${repl};;
          esac
        ;;
        "iso")
          case $2 in
          "") error "Expected a Device name";;
          *)
            if grep -wq "$2" <<<"${nixosConfigurations}" &> /dev/null
            then
              echo "Building '$2' Image..."
              nom build ${path.system}#nixosConfigurations."$2".config.system.build.images.iso
            else
              error "Unknown Device '$2'" "# Available Devices #\n ${nixosConfigurations}"
            fi
          ;;
          esac
          case $3 in
          "") echo "The '--burn' Option can be used to Flash the Image onto a USB";;
          "--burn")
            case $4 in
            "") error "Expected a 'path' to USB Drive";;
            *)
              IMAGE=$(find ./result/iso -type f -name "*.iso")
              sudo dd if="$IMAGE" of="$4" status=progress bs=1M
            ;;
            esac
          ;;
          *) error "Unknown Option '$3'";;
          esac
        ;;
        "list")
          case $2 in
          "") installed;;
          *) find=$(installed | grep "$2")
          if [ -z "$find" ]
            then
              missing "$2" "Package '$2' not found"
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
            package=$(installed | grep "$2")
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
                missing "$2" "Package '$2' is invalid"
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
        "run")
          export NIXPKGS_ALLOW_UNFREE=1
          if [[ "$2" == *[:/]* ]] || grep -wq "$2" <<<"${list inputs}"
          then
            nix run "$2"#"$3" --impure -- "''${@:4}"
          else
            nix run ${path.system}#"$2" --impure -- "''${@:3}"
          fi
        ;;
        "search")
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
        "secret")
          case $2 in
          "") error "Expected an Option" "${usage.secret}";;
          help|--help|-h) echo "${usage.secret}";;
          "create")
            case $3 in
            "") error "Expected 'name' of Secret";;
            *)
              echo "Creating Secret '$3'..."
              sops --config ${path.sops} -i ${path.system}/"$3".secret
            ;;
            esac
          ;;
          "edit")
            case $3 in
            "") error "Expected 'name' of Secret";;
            *)
              if secret_exists "$3"
              then
                echo "Editing Secret '$3'..."
                find ${path.system} -name "$3".secret -exec sops --config ${path.sops} -i {} \+
              else
                error "Unknown Secret '$3'"
              fi
            ;;
            esac
          ;;
          "list")
            echo "## Secrets in ${path.system} ##"
            grep / ${path.sops} | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path.system}/|' | xargs tree -C --noreport -P '*.secret' -I '_*' | sed 's/\.secret//'
          ;;
          "show")
            if secret_exists "$3"
            then
              echo "Showing Secret '$3'..."
              find ${path.system} -name "$3".secret -exec sops --config ${path.sops} -d {} \+
            else
              error "Unknown Secret '$3'"
            fi
          ;;
          "update")
            echo "Updating Secrets..."
            find ${path.system} -name '*.secret' ! -name '_*' -exec sops --config ${path.sops} updatekeys {} \;
          ;;
          *) error "Unknown Option '$2'" "${usage.secret}";;
          esac
        ;;
        "setup")
          if [ -d ${path.persist} ]; then
            DIR=${path.persist}${path.system}
          else
            DIR=${path.system}
          fi

          echo "Cloning Repository..."
          sudo git clone --recurse-submodules ${path.repo} "$DIR"
          pushd "$DIR" &> /dev/null; sudo git config core.fileMode false; popd &> /dev/null
          sudo chgrp -R keys "$DIR"
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
          find ./keys -name '*.gpg' -exec sudo gpg --homedir ${path.gpg} --import {} \+
          rm -rf ./keys
          newline

          nixos apply --activate
        ;;
        "shell")
          case $2 in
          "") nix develop ${path.system} --command "$SHELL";;
          *)
            if grep -wq "$2" <<<"${devShells}" &> /dev/null
            then
              nix develop ${path.system}#"$2" --command "$SHELL"
            else
              error "Unknown Shell '$2'" "# Available Shells #\n  ${devShells}"
            fi
          ;;
          esac
        ;;
        "update")
          case $2 in
          help|--help|-h) echo "${usage.update}";;
          "--pkgs")
            echo "Updating Packages..."
            pushd ${path.system}/packages &> /dev/null
            bash ${./packages.sh}
            popd &> /dev/null
          ;;
          "--commit")
            echo "Updating Flake Inputs..."
            nix flake update --flake ${path.system} --commit-lock-file
          ;;
          "")
            echo "Updating Flake Inputs..."
            nix flake update --flake ${path.system}
          ;;
          *)
            echo "Updating Flake Input '$2'..."
            if [ -z "$3" ]
            then
              nix flake update --flake ${path.system} "$2"
            else

              nix flake update --flake ${path.system} "$2" --override-input "$2" "$3"
            fi
          ;;
          esac
        ;;
        *) error "Unknown Option '$1'" "${usage.script}";;
        esac
      '';
    }
  )
