{ system, version, files, lib, inputs, pkgs, ... }:
{
  ## User Configuration Function ##
  mkUser = { username, description, groups, uid, shell }:
  {
    # User Creation
    _module.args = { inherit username; };
    users.users."${username}" =
    {
      # Profile
      name = username;
      description = description;
      isNormalUser = true;
      inherit uid;

      # Groups
      group = "users";
      extraGroups = groups;
    };

    # Shell Configuration
    shell.enable = true;
    shell.shell = shell;

    # Home Configuration
    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "bak";
    home-manager.users."${username}" =
    {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = version;
      programs.home-manager.enable = true;
      systemd.user.startServices = true;
    };
  };
}
