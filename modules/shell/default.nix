{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.user.shell;
in rec {
  imports = [ ./zsh.nix ];

  options.user.shell = {
    utilities = mkEnableOption "Additional Shell Utilities";
    choice = mkOption {
      description = "User Shell Choice";
      type = types.str;
      default = "bash";
    };
  };

  ## Shell Configuration ##
  config = mkMerge [
    {
      user.settings.shell = pkgs."${cfg.choice}";

      # Environment Settings
      environment = {
        shells = [ pkgs.bashInteractive ];
        variables.EDITOR = "nano -Ll";
      };
    }

    (mkIf cfg.utilities {
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
        # Command Not Found Helper
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
