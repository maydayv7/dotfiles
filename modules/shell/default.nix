{ config, lib, pkgs, files, ... }:
let
  shell = config.user.shell;
in rec
{
  imports = [ ./zsh.nix ];

  options.user.shell = lib.mkOption
  {
    description = "User Shell Choice";
    type = lib.types.str;
    default = "bash";
  };

  ## Shell Configuration ##
  config =
  {
    user.settings.shell = pkgs."${shell}";

    # Environment Variables
    environment.variables =
    {
      EDITOR = "nano -Ll";
    };

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
  };
}
