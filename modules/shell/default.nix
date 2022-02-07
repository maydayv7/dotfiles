{ config, lib, pkgs, files, ... }:
with files;
with { inherit (lib) mkEnableOption mkOption mkIf mkMerge types util; }; {
  imports = util.map.module ./.;

  options.shell = {
    utilities = mkEnableOption "Enable Additional Shell Utilities";
    support = mkOption {
      description = "List of Additional Supported Shells";
      type = types.listOf (types.enum (util.map.module' ./.));
      default = [ "bash" ];
    };
  };

  ## Shell Configuration ##
  config = mkMerge [
    {
      # Environment Settings
      environment = {
        systemPackages = with pkgs; [ nano neofetch ];

        # Default Editor
        variables.EDITOR = "nano";
        etc.nanorc.text = files.nano;
      };
    }

    (mkIf config.shell.utilities {
      # Utilities
      environment.systemPackages = with pkgs; [
        bat
        etcher
        exa
        fd
        file
        lolcat
        shellcheck
        stylua
        tree
      ];

      # Program Configuration
      programs = {
        # Command Not Found Search
        command-not-found.enable = true;

        # Command Correction Helper
        thefuck = {
          enable = true;
          alias = "fix";
        };
      };

      user = {
        persist.dirs = [ ".local/share/direnv" ];
        home = {
          programs = {
            # DirENV Support
            direnv = {
              enable = true;
              nix-direnv.enable = true;
            };

            # Bat Configuration
            bat = {
              enable = true;
              config = {
                style = "full";
                italic-text = "always";
                theme = "Monokai Extended Bright";
                map-syntax = [ ".ignore:Git Ignore" ];
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
            cat = "bat";
            colors = "${scripts.colors}";
            edit = "sudo $EDITOR";
            l = "ls --color --group-directories-first";
            ls = "exa -b -h -l -F --octal-permissions --icons --time-style iso";
            sike = "neofetch";
          };
        };
      };
    })
  ];
}
