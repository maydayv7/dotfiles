{ system, version, lib, inputs, pkgs, ... }:
{
  ## User Configuration Function ##
  mkUser = { username, description, groups, uid, shell }:
  let
    password = (builtins.readFile ("${inputs.secrets}/passwords" + "/${username}"));
  in
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
      initialHashedPassword = password;
    };
  };

  ## User Home Configuration Function ##
  mkHome = { username, roles }:
  inputs.home-manager.lib.homeManagerConfiguration
  {
    inherit system username pkgs;
    stateVersion = version;
    homeDirectory = "/home/${username}";
    configuration =
    let
      # User Roles Import Function
      mkRole = name: import (../../roles/user + "/${name}");
      user_roles = (builtins.map (r: mkRole r) roles);

      # User Home Configuration Modules
      user_modules =
      [
        ../../modules/user/dotfiles
        ../../modules/user/keys
        ../../modules/user/shell
      ];
    in
    {
      # Modulated Configuration Imports
      _module.args = { inherit inputs; };
      imports = user_roles ++ user_modules;

      # Home Manager Configuration
      home.username = username;
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
