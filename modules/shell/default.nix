{ config, lib, pkgs, files, ... }:
let
  inherit (lib) hm mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.user.shell;
in rec {
  imports = [ ./zsh.nix ];

  options.user.shell = {
    utilities = mkEnableOption "Enable Additional Shell Utilities";
    choice = mkOption {
      description = "User Shell Choice";
      type = types.enum [ "bash" "zsh" ];
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

        # Default Editor
        variables.EDITOR = "nano";
        etc.nanorc.text = files.nano;
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
