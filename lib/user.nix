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
      _module.args.inputs = inputs;
      systemd.user.startServices = true;
      home.username = username;
      programs.home-manager.enable = true;
      
      # Home Activation Script
      home.activation =
      {
        screenshotsDir = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
        ''
          $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/Pictures/Screenshots
        '';
        
        profilePic = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
        ''
          $DRY_RUN_CMD sudo cp -av $VERBOSE_ARG ~/.local/share/backgrounds/Profile.png /var/lib/AccountsService/icons/${username}
        '';
      };
    };
  };
}
