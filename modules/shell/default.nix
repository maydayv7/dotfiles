{ username, pkgs, files, ... }:
rec
{
  imports = [ ./zsh.nix ];

  ## Shell Configuration ##
  config =
  {
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
