{ config, lib, username, inputs, ... }:
rec
{
  # Home Manager Module
  imports = [ inputs.home.nixosModules.home-manager ];

  ## Install Media User Configuration ##
  config =
  {
    # Default User
    users.users."${username}" =
    {
      name = "${username}";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      uid = 1000;
      initialPassword = "password";
      useDefaultShell = true;
    };

    # User Login
    services.xserver.displayManager.autoLogin =
    {
      enable = true;
      user = "${username}";
    };

    # Security Settings
    security.sudo.extraConfig =
    ''
      Defaults pwfeedback
      ${username} ALL=(ALL) NOPASSWD:ALL
    '';
  };
}
