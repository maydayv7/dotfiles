{
  system ? builtins.currentSystem,
  lib,
  util,
  inputs,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (inputs) self;
  inherit (util.map) list;
  inherit (lib) licenses recursiveUpdate;

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
        iso 'variant' [ --burn ]        - Builds Image for Specified Install Media or Device [ Burns '.iso' to USB ]
        list [ 'pattern' ]              - Lists all Installed Packages [ Returns Matches ]
        locate 'package'                - Locates Installed Package
        run [ 'path' ] 'command'        - Runs Specified Command [ from 'path' ] (Wraps 'nix run')
        save                            - Saves Configuration State to Repository
        search 'term' [ 'source' ]      - Searches for Packages [ Providing 'term' ] or Configuration Options
        secret 'choice' [ 'path' ]      - Manages 'sops' Encrypted Secrets
        setup                           - Sets up NixOS System (on First Boot)
        shell [ 'name' ]                - Opens desired Nix Developer Shell
        update [ 'repo' / --'option' ]  - Manages System Package Updates
    '';

    apply = ''
      # Usage #
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
  recursiveUpdate {
    meta = {
      mainProgram = "nixos";
      description = "System Management Script";
      homepage = files.path.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  } (pkgs.writeShellApplication {
    name = "nixos";
    runtimeInputs = with pkgs; [
      cachix
      coreutils
      git
      gnugrep
      gnupg
      gnused
      jq
      manix
      nixFlakes
      nvd
      sops
      tree
      wine.mkwindowsapp-tools
    ];

    text = ''
      set +eu
      ${scripts.commands}

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
          echo "Applying Configuration..."
          sudo nixos-rebuild switch --flake ${path.system}#
        ;;
        "--activate")
          case $3 in
          "")
            echo "Activating Configuration..."
            sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
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
          temp nixos-build
          pushd "$TEMP" &> /dev/null
          echo "Building Configuration..."
          if nixos-rebuild build --flake ${path.system}#
          then
            echo "Processing Delta..."
            nvd diff /run/current-system result
          else
            error "Couldn't build generation successfully"
          fi
          popd &> /dev/null
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
        *) error "Unknown Option '$2'" "${usage.apply}";;
        esac
      ;;
      "cache")
        if [ -z "$2" ]
          then
            error "Expected a Build Command"
          else
            echo "Executing Command '" "''${@:2}" "'..."
            cachix authtoken "$(find ${path.system} -name cachix-token.secret -exec sops --config ${sops} -d {} \+)"
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
        "") error "Expected a Variant of Install Media or Device";;
        *)
          if grep -wq "$2" <<<"${installMedia}" &> /dev/null
          then
            echo "Building '$2' Install Media Image..."
            nix build ${path.system}#installMedia."$2".config.system.build.isoImage && echo "The Image is located at './result/iso/nixos.iso'"
          elif grep -wq "$2" <<<"${nixosConfigurations}" &> /dev/null
          then
            echo "Building '$2' Device Image..."
            nix build  ${path.system}#nixosConfigurations."$2".config.formats.iso
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
      "run")
        export NIXPKGS_ALLOW_UNFREE=1
        if [[ "$2" == *[:/]* ]] || grep -wq "$2" <<<"${list inputs + "nixpkgs"}"
        then
          nix run "$2"#"$3" --impure -- "''${@:4}"
        else
          nix run ${path.system}#"$2" --impure -- "''${@:3}"
        fi
      ;;
      "save")
        echo "Saving Changes..."
        pushd ${path.system} &> /dev/null
        git stash
        git pull --rebase
        git branch save
        git checkout save
        git stash pop
        git add .
        git commit
        git push --set-upstream origin save --force
        popd &> /dev/null
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
            sops --config ${sops} -i ${path.system}/"$3".secret
          ;;
          esac
        ;;
        "edit")
          case $3 in
          "") error "Expected 'name' of Secret";;
          *)
            if find ${path.system} -name "$3".secret | grep "secret" &> /dev/null
            then
              echo "Editing Secret '$3'..."
              find ${path.system} -name "$3".secret -exec sops --config ${sops} -i {} \+
            else
              error "Unknown Secret '$3'"
            fi
          ;;
          esac
        ;;
        "list")
          echo "## Secrets in ${path.system} ##"
          grep / ${sops} | sed -e 's|- path_regex:||' -e 's/\/\.\*\$//' -e 's|   |${path.system}/|' | xargs tree -C --noreport -P '*.secret' -I '_*' | sed 's/\.secret//'
        ;;
        "show")
          if find ${path.system} -name "$3".secret | grep "secret" &> /dev/null
          then
            echo "Showing Secret '$3'..."
            find ${path.system} -name "$3".secret -exec sops --config ${sops} -d {} \+
          else
            error "Unknown Secret '$3'"
          fi
        ;;
        "update")
          echo "Updating Secrets..."
          find ${path.system} -name '*.secret' ! -name '_*' -exec sops --config ${sops} updatekeys {} \;
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
        git clone --recurse-submodules ${path.repo} "$DIR"
        pushd "$DIR" &> /dev/null; git config core.fileMode false; popd &> /dev/null
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
        find ./keys -name '*.gpg' -exec gpg --homedir ${files.gpg} --import {} \+
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
  })
