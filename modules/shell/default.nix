{ config, lib, pkgs, files, ... }:
with files;
with { inherit (lib) mkEnableOption mkIf mkMerge util; }; {
  imports = util.map.module ./.;

  options.shell.utilities = mkEnableOption "Enable Additional Shell Utilities";

  ## Shell Configuration ##
  config = mkMerge [
    {
      # Environment Settings
      environment = {
        systemPackages = [ pkgs.nano ];

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
        neofetch
        shellcheck
        stylua
        tree
      ];

      ## Program Configuration
      # Faster 'nix-shell'
      services.lorri.enable = true;
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
              nix-direnv = {
                enable = true;
                enableFlakes = true;
              };
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
            nixos-option =
              "${pkgs.nixos-option} -I nixpkgs=${path.system}/lib/compat";
          };
        };
      };
    })
  ];
}
