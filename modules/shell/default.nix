{ config, lib, pkgs, files, ... }:
let
  inherit (lib) mkIf types mkOption mkEnableOption mkMerge;
  cfg = config.user.shell;
in rec
{
  imports = [ ./zsh.nix ];

  options.user.shell =
  {
    utilities = mkEnableOption "Additional Shell Utilities";
    choice = mkOption
    {
      description = "User Shell Choice";
      type = types.str;
      default = "bash";
    };
  };

  ## Shell Configuration ##
  config = mkMerge
  [
    {
      user.settings.shell = pkgs."${cfg.choice}";

      # Environment Variables
      environment.variables =
      {
        EDITOR = "nano -Ll";
      };
    }

    (mkIf cfg.utilities
    {
      # Utilities
      environment.systemPackages = with pkgs;
      [
        etcher
        exa
        fd
        file
        lolcat
        nano
        neofetch
        tree
      ];

      # Neofetch Config
      user.home.home.file.".config/neofetch/config.conf".text = files.fetch;

      programs =
      {
        # Command Not Found Helper
        command-not-found.enable = true;

        # GPG Key Signing
        gnupg.agent.enable = true;

        # X11 SSH Password Auth
        ssh.askPassword = "";
      };
    })
  ];
}
