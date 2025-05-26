{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (util.map) modules;
  inherit (builtins) listToAttrs map;
  inherit (lib)
    getExe'
    mkEnableOption
    mkBefore
    mkIf
    mkMerge
    nameValuePair
    ;

  shells = lib.remove "prompt" (modules.name ./.);
in
{
  ## SHELL Configuration ##
  imports = modules.list ./.;

  options.shell.utilities = mkEnableOption "Enable Additional Shell Utilities";

  config = mkMerge [
    {
      # Text Editor
      environment.variables."EDITOR" = "nano";
      programs.nano = {
        enable = true;
        syntaxHighlight = true;
        nanorc = files.nano;
      };
    }

    (mkIf config.shell.utilities {
      environment = with files; {
        # Utilities
        systemPackages = with pkgs; [
          bat
          btop
          eza
          fastfetch
          fd
          hstr
          lolcat
          micro
          tree
          yazi
        ];

        # Fetch
        etc."fastfetch/config.jsonc".text = fetch;

        # Command Aliases
        shellAliases = {
          hi = "echo 'Hi there. How are you?'";
          bye = "exit";
          dotfiles = "cd ${path.system}";

          # Programs
          c = "bat";
          l = "eza -b -h -l -F --octal-permissions --time-style iso";
          grep = "grep --color";
          colors = "${scripts.colors}";
          sike = "fastfetch";
        };
      };

      ## Program Configuration
      services.lorri.enable = true; # Faster 'nix shell'
      programs =
        listToAttrs (
          map (
            shell:
            nameValuePair shell {
              promptInit = mkBefore ''eval $(${getExe' pkgs.thefuck "thefuck"} --alias "fix")'';
            }
          ) shells
        )
        // {
          command-not-found.enable = true; # Command Not Found Search
          yazi.enable = true; # File Browser

          # Command Correction Helper
          thefuck = {
            enable = true;
            alias = "fix"; # Use 'fix' to correct previous command
          };

          # DirENV Support
          direnv = {
            enable = true; # Load Shell Variables from '.envrc'
            nix-direnv.enable = true;
          };

          # Bat Configuration
          bat = {
            enable = true;
            settings = {
              style = "full";
              italic-text = "always";
              map-syntax = [ ".ignore:Git Ignore" ];
            };
          };
        };

      user = {
        persist = {
          files = [ ".hstr_favorites" ];
          directories = [
            ".config/micro"
            ".local/share/direnv"
          ];
        };

        homeConfig = {
          programs = {
            btop.enable = true; # Resource Monitor
            hstr.enable = true; # Command History Browser

            # Eza Configuration
            eza = {
              enable = true;
              colors = "auto";
              icons = "auto";
              git = true;
              extraOptions = [ "--group-directories-first" ];
            };

            # Micro Configuration
            micro = {
              enable = true;
              settings = {
                autoindent = true;
                backup = true;
                clipboard = "external";
                cursorline = true;
                eofnewline = false;
                helpsplit = "vsplit";
                hltrailingws = true;
                infobar = true;
                matchbrace = true;
                keymenu = true;
                mouse = true;
                reload = "prompt";
                ruler = true;
                saveundo = true;
                smartpaste = true;
                statusline = true;
                syntax = true;
              };
            };
          };
        };
      };
    })
  ];
}
