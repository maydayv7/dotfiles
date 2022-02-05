{ config, lib, pkgs, files, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  enable = config.shell.utilities;
in {
  imports = [ ./zsh.nix ];

  options.shell = {
    utilities = mkEnableOption "Enable Additional Shell Utilities";
    support = mkOption {
      description = "List of Supported Shells";
      type = types.listOf (types.enum [ "bash" "zsh" ]);
      default = [ "bash" ];
    };
  };

  ## Shell Configuration ##
  config = mkMerge [
    {
      # Environment Settings
      user.persist = {
        files = [ ".bash_history" ];
        dirs = [ ".local/share/bash" ];
      };

      environment = {
        shells = [ pkgs.bashInteractive ];

        # Default Editor
        variables.EDITOR = "nano";
        etc.nanorc.text = files.nano;
      };
    }

    (mkIf enable {
      # Utilities
      environment.systemPackages = with pkgs; [
        bat
        etcher
        exa
        fd
        file
        nano
        shellcheck
        tree
      ];

      # DirENV Support
      user = {
        persist.dirs = [ ".local/share/direnv" ];
        home.programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };

      programs = {
        # Command Not Found Search
        command-not-found.enable = true;

        # Command Correction Helper
        thefuck = {
          enable = true;
          alias = "fix";
        };
      };
    })
  ];
}
