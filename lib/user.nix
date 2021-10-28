{ system, lib, inputs, pkgs, ... }:
{
  ## User Configuration Function ##
  mkUser = { name, description, groups, uid, shell, ... }:
  {
    users.users."${name}" =
    {
      # Profile
      name = name;
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
      initialHashedPassword = (builtins.readFile ("${inputs.secrets}/passwords" + "/${name}"));
    };
  };

  ## User Home Configuration Function ##
  mkHome = { username, roles, version, ... }:
  inputs.home-manager.lib.homeManagerConfiguration
  {
    inherit system username pkgs;
    stateVersion = version;
    homeDirectory = "/home/${username}";
    configuration =
    let
      # User Roles Import Function
      mkRole = name: import (../roles/user + "/${name}");
      user_roles = (builtins.map (r: mkRole r) roles);

      # User Configuration Modules
      user_modules = [ ../modules/user ];
    in
    {
      _module.args =
      {
        inherit inputs;
      };

      # Modulated Configuration Imports
      imports = user_roles ++ user_modules;

      # Home Manager Configuration
      home.username = username;
      home.activate = true;
      home.dotfiles = true;
      programs.home-manager.enable = true;
      systemd.user.startServices = true;

      # Shell Configuration
      shell.git.enable = true;
      shell.git.key = "CF616EB19C2765E4";
      shell.terminal.enable = true;
      shell.zsh.enable = true;
    };
  };
}
