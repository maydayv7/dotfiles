{ config, lib, username, pkgs, files, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types;
  enable = config.shell.enable;
  shell = config.shell.shell;
in rec
{
  imports = [ ./zsh.nix ];

  options.shell =
  {
    enable = mkEnableOption "Enable Shell Configuration";
    shell = mkOption
    {
      description = "User Shell Choice";
      type = types.str;
      default = "bash";
    };
  };

  ## Shell Configuration ##
  config = mkIf enable
  {
    # Environment Variables
    environment.variables =
    {
      EDITOR = "nano -Ll";
    };

    # User Shell Configuration
    users.users."${username}" =
    {
      useDefaultShell = false;
      shell = pkgs."${shell}";
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
    home-manager.users."${username}".home.file.".config/neofetch/config.conf".text = files.fetch;

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
