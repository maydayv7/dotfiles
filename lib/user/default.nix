{ system, version, secrets, lib, inputs, pkgs, ... }:
{
  ## User Configuration Function ##
  mkUser = { username, description, groups, uid, shell, roles }:
  {
    users.users."${username}" =
    {
      # Profile
      name = username;
      description = description;
      isNormalUser = true;
      uid = uid;

      # Groups
      group = "users";
      extraGroups = groups;

      # Shell
      useDefaultShell = false;
      shell = shell;

      # Password
      initialHashedPassword = secrets."${username}";
    };

    # Home Configuration
    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "bak";
    home-manager.sharedModules = [ ../../modules/user ];
    home-manager.users."${username}" =
    let
      # User Roles Import Function
      mkRole = name: import (../../roles/user + "/${name}");
      user_roles = (builtins.map (r: mkRole r) roles);
    in
    {
      # Modulated Configuration Imports
      _module.args = { inherit secrets inputs; };
      imports = user_roles;

      # Home Manager Configuration
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = version;
      dotfiles.enable = true;
      programs.home-manager.enable = true;
      systemd.user.startServices = true;

      # Shell Configuration
      keys.enable = true;
      shell.git.enable = true;
      shell.terminal.enable = true;
      shell.zsh.enable = true;
    };
  };
}
