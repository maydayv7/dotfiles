{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (util.map) modules;
  inherit (builtins) listToAttrs map;
  inherit (lib) getExe' mkEnableOption mkBefore mkIf mkMerge nameValuePair;
in {
  imports = modules.list ./.;

  options.shell.utilities = mkEnableOption "Enable Additional Shell Utilities";

  ## Shell Configuration ##
  config = mkMerge [
    {
      # Environment Settings
      environment = {
        systemPackages = [pkgs.nano];

        # Default Editor
        variables."EDITOR" = "nano";
        etc.nanorc.text = files.nano;
      };
    }

    (mkIf config.shell.utilities {
      # Utilities
      environment.systemPackages = with pkgs; [
        bat
        browsh
        btop
        eza
        fd
        lolcat
        neofetch
        tree
        yazi
      ];

      ## Program Configuration
      services.lorri.enable = true; # Faster 'nix shell'
      programs = {
        command-not-found.enable = true; # Command Not Found Search

        # Command Correction Helper
        thefuck = {
          enable = true;
          alias = "fix"; # Use 'fix' to correct previous command
        };
      };

      user = {
        persist = {
          files = [".hstr_favorites"];
          directories = [".local/share/direnv"];
        };

        homeConfig = {
          programs =
            listToAttrs (map (shell:
              nameValuePair shell
              {initExtra = mkBefore ''eval $(${getExe' pkgs.thefuck "thefuck"} --alias "fix")'';})
            (modules.name ./.))
            // {
              btop.enable = true; # Resource Monitor
              hstr.enable = true; # Command History Browser
              #yazi.enable = true # File Browser #!# Wait for release

              # DirENV Support
              direnv = {
                enable = true; # Load Shell Variables from '.envrc'
                nix-direnv.enable = true;
              };

              # Bat Configuration
              bat = {
                enable = true;
                config = {
                  style = "full";
                  italic-text = "always";
                  map-syntax = [".ignore:Git Ignore"];
                };
              };
            };

          # Neofetch
          home.file.".config/neofetch/config.conf".text = fetch;

          # Command Aliases
          home.shellAliases = {
            hi = "echo 'Hi there. How are you?'";
            bye = "exit";
            dotfiles = "cd ${path.system}";

            # Programs
            c = "bat";
            l = "eza -b -h -l -F --octal-permissions --icons --time-style iso";
            grep = "grep --color";
            colors = "${scripts.colors}";
            edit = "sudo $EDITOR";
            sike = "neofetch";
          };
        };
      };
    })
  ];
}
