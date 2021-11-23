{ system, version, files, secrets, lib, inputs, pkgs, ... }:
{
  ## User Configuration Function ##
  mkUser = { username, description, groups, uid, shell, apps }:
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

    # Program Configuration
    inherit apps;
    shell.enable = true;
    shell.shell = shell;

    # Home Configuration
    imports = [ inputs.home.nixosModules.home-manager ];
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
