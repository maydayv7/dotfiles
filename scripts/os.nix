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

  list = attrs: builtins.foldl' (x: y: x + y + " ") "" (builtins.attrNames attrs);
  devShells = list self.devShells."${pkgs.stdenv.system}";
  nixosConfigurations = list self.nixosConfigurations;

  # Usage Description
  usage = {
    script = ''
      # Legend #
        xxx - Command
        [ ] - Optional                  - Description
        ' ' - Variable

      # Usage #
        apply [ --'option' ]            - Applies device and user config
        cache 'command'                 - Pushes binary output to Cachix
        check [ --trace ]               - Checks system configuration [ Displays error trace ]
        clean [ --all ]                 - Cleans and optimises Nix Store
        explore                         - Opens interactive shell to explore syntax and config
        iso 'variant' [ --burn ]        - Builds image for specified device [ Burns '.iso' to USB ]
        list [ 'pattern' ]              - Lists all installed packages [ Returns matches ]
        locate 'package'                - Locates installed package
        run [ 'path' ] 'command'        - Runs specified command [ from 'path' ] (Wraps 'nix run')
        search 'term' [ 'source' ]      - Searches for packages [ providing 'term' ] or config options
        secret 'choice' [ 'path' ]      - Manages 'sops' encrypted secrets
        setup                           - Sets up system (on first boot)
        shell [ 'name' ]                - Opens desired Nix Developer Shell
        update [ 'repo' / --'option' ]  - Manages system package updates
    '';

    apply = ''
      # Usage #
        'specialisation'             - Activates specified system specialisation
        --activate [ home ]          - Activates current [ home ] config
        --boot                       - Applies config on boot
        --rollback [ 'generation' ]  - Reverts to last [ or specified ] build
        --test                       - Tests config build
    '';

    search = ''
      # Usage #
        cmd.'command'              - Searches for package providing 'command'
        pkgs.'package' [ 'repo' ]  - Searches for 'package' [ In Repository ]
        'term'                     - Searches for packages and config option (matching 'term')
    '';

    secret = ''
      # Usage #
        create 'path'  - Creates desired secret
        edit 'name'    - Edits desired secret
        list           - Lists all 'sops' encrypted secrets
        show 'name'    - Shows desired secret
        update         - Updates secrets to defined keys
    '';

    update = ''
      # Usage #
        --pkgs               - Automatically updates custom packages
        --commit             - Updates 'inputs' and commits changes
        'repo' [ 'source' ]  - Updates 'repo' input [ To specified 'source' ]
    '';
  };
in
  recursiveUpdate
  {
    meta = {
      mainProgram = "os";
      description = "System Management Script";
      homepage = path.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
  (
    pkgs.writeShellApplication {
      name = "os";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        gnused
        git
        jq
        tree
        gnupg
        sops

        nixFlakes
        cachix
        manix
        nh
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
        "") error "Expected an option" "${usage.script}";;
        help|--help|-h) echo -e "## Tool for NixOS System Management ##\n${usage.script}";;
        "apply")
          case $2 in
          help|--help|-h) echo "${usage.apply}";;
          "")
            echo "Applying Configuration..."
            nh os switch ${path.system}
          ;;
          "--activate")
            case $3 in
            "")
              SPEC=$(cat /etc/specialisation 2> /dev/null || true)
              if [ -z "$SPEC" ]
              then
                echo "Activating Configuration..."
                sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
              else
                echo "Activating Configuration ($SPEC)..."
                sudo /nix/var/nix/profiles/system/specialisation/"$SPEC"/bin/switch-to-configuration switch
              fi
            ;;
            "home")
              echo "Applying Home Configuration..."
              sudo systemctl restart home-manager-"$USER"
            ;;
            *) error "Unknown option '$3'";;
            esac
          ;;
          "--boot")
            echo "Applying Configuration..."
            if nh os boot ${path.system}
            then
              restart
            else
              error "Couldn't build generation successfully"
            fi
          ;;
          "--test")
            echo "Testing Configuration..."
            nh os test ${path.system}
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
              sudo nix-env --switch-generation "$3" -p "/nix/var/nix/profiles/system" && os apply --activate
            ;;
            esac
          ;;
          *)
            SPECIALISATIONS=$(ls -1 /nix/var/nix/profiles/system/specialisation)
            if grep -wq "$2" <<<"$SPECIALISATIONS" &> /dev/null
            then
              echo "Applying Configuration ($2)..."
              nh os switch ${path.system} -s "$2"
            else
              error "Unknown option '$2'\n${usage.apply}" "# Available Specialisations #\n$SPECIALISATIONS"
            fi
          ;;
          esac
        ;;
        "cache")
          if [ -z "$2" ]
            then
              error "Expected a build command"
            else
              echo "Executing command '" "''${@:2}" "'..."
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
          if [ "$EUID" -ne 0 ] && [ "$2" != "--all" ]
          then
            echo "Running Garbage Collection..."
            nh clean user --optimise
            warn "Run as 'root' or use '--all' to clean system generations"
          else
            echo "Running Garbage Collection..."
            nh clean all --optimise
            sudo rm -rf /run/secrets/*
            os apply --activate
          fi
        ;;
        "explore")
          case $2 in
          "") nix repl --arg host true --arg path ${path.system} --file ${repl};;
          *) nix repl --arg path "$(readlink -f "$2" | sed 's|/flake.nix||')" --file ${repl};;
          esac
        ;;
        "iso")
          case $2 in
          "") error "Expected a device name";;
          *)
            if grep -wq "$2" <<<"${nixosConfigurations}" &> /dev/null
            then
              echo "Building '$2' Image..."
              nom build ${path.system}#nixosConfigurations."$2".config.system.build.images.iso
            else
              error "Unknown device '$2'" "# Available devices #\n ${nixosConfigurations}"
            fi
          ;;
          esac
          case $3 in
          "") echo "The '--burn' option can be used to flash the image to a USB";;
          "--burn")
            case $4 in
            "") error "Expected 'path' to USB";;
            *)
              IMAGE=$(find ./result/iso -type f -name "*.iso")
              sudo dd if="$IMAGE" of="$4" status=progress bs=1M
            ;;
            esac
          ;;
          *) error "Unknown option '$3'";;
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
          "") error "Expected package name";;
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
          "") error "Expected an option" "${usage.search}";;
          help|--help|-h) echo "${usage.search}";;
          cmd.*)
            command="''${2//cmd\./}"
            echo "Searching for Package providing command '$command'..."
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
            echo "Searching for package '$package'..."
            if [ -z "$3" ]
            then
              nix search nixpkgs#"$package"
            else
              nix search "$3"#"$package"
            fi
          ;;
          *)
            echo "Searching for term '$2'..."
            manix "$2"
          ;;
          esac
        ;;
        "secret")
          case $2 in
          "") error "Expected an option" "${usage.secret}";;
          help|--help|-h) echo "${usage.secret}";;
          "create")
            case $3 in
            "") error "Expected 'name' of secret";;
            *)
              echo "Creating secret '$3'..."
              sops --config ${path.sops} -i ${path.system}/"$3".secret
            ;;
            esac
          ;;
          "edit")
            case $3 in
            "") error "Expected 'name' of secret";;
            *)
              if secret_exists "$3"
              then
                echo "Editing secret '$3'..."
                find ${path.system} -name "$3".secret -exec sops --config ${path.sops} -i {} \+
              else
                error "Unknown secret '$3'"
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
              echo "Showing secret '$3'..."
              find ${path.system} -name "$3".secret -exec sops --config ${path.sops} -d {} \+
            else
              error "Unknown secret '$3'"
            fi
          ;;
          "update")
            echo "Updating secrets..."
            find ${path.system} -name '*.secret' ! -name '_*' -exec sops --config ${path.sops} updatekeys {} \;
          ;;
          *) error "Unknown option '$2'" "${usage.secret}";;
          esac
        ;;
        "setup")
          if [ -d ${path.persist} ]
          then
            DIR=${path.persist}${path.system}
          else
            DIR=${path.system}
          fi

          echo "Cloning Repository..."
          sudo git clone --recurse-submodules ${path.repo} "$DIR"
          pushd "$DIR" &> /dev/null; sudo git config core.fileMode false; popd &> /dev/null
          sudo chgrp -R keys "$DIR"
          newline

          read -rp "Enter path to GPG Keys (path/.git): " KEY
          LINK='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
          if [ -z "$KEY" ]
          then
            error "Path cannot be empty"
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

          os apply --activate
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
            echo "Updating Flake inputs..."
            nix flake update --flake ${path.system} --commit-lock-file
          ;;
          "")
            echo "Updating Flake inputs..."
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
        *) error "Unknown option '$1'" "${usage.script}";;
        esac
      '';
    }
  )
