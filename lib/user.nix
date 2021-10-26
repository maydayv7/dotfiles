{ system, lib, inputs, pkgs, ... }:
with builtins;
{
  ## User Configuration ##
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
      initialHashedPassword = (readFile ("${inputs.secrets}/passwords" + "/${name}"));
    };
  };
  
  ## User Home Configuration ##
  mkHome = { username, roles, version, ... }:
  inputs.home-manager.lib.homeManagerConfiguration
  {
    inherit system username pkgs;
    stateVersion = version;
    homeDirectory = "/home/${username}";
    configuration =
    let
      # Module Import Function
      mkRole = name: import (../users + "/${name}");
      user_roles = map (r: mkRole r) roles;
      
      # Shared User Roles
      shared_roles =
      [
        ../users/dotfiles
        ../users/terminal
        ../users/theme
        ../scripts/home
      ];
    in
    {
      _module.args =
      {
        inherit inputs username;
      };
      
      # Modulated Configuration Imports
      imports = shared_roles ++ user_roles;
      
      # Package Configuraton
      nixpkgs.config.allowUnfree = true;
      
      # Home Manager Configuration
      home.username = username;
      programs.home-manager.enable = true;
      systemd.user.startServices = true;
    };
  };
}
