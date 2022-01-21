{ config, lib, pkgs, files, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  enable = config.shell.utilities;
in rec {
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
        etcher
        exa
        fd
        file
        nano
        shellcheck
        tree
      ];

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
