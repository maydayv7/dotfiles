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
      initialPassword = "password";
      passwordFile = "/etc/nixos/secrets/passwords/${name}";
    };
  };
  
  ## User Home Configuration ##
  mkHome = { username, version, modules, ... }:
  inputs.home-manager.lib.homeManagerConfiguration
  {
    inherit system username pkgs;
    stateVersion = version;
    homeDirectory = "/home/${username}";
    configuration =
    let
      # Module Import Function
      mkModule = name: import (../users + "/${name}");
      user_modules = map (r: mkModule r) modules;
    in
    {
      # Modulated Configuration Imports
      imports = user_modules;
      
      # Package Configuraton
      nixpkgs.config.allowUnfree = true;
      
      # Home Manager Configuration
      systemd.user.startServices = true;
      home.username = username;
      _module.args.inputs = inputs;
    };
  };
}
