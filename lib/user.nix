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
      _module.args =
      {
        inherit inputs;
      };
      
      # Modulated Configuration Imports
      imports = user_modules;
      
      # Package Configuraton
      nixpkgs.config.allowUnfree = true;
      
      # Home Manager Configuration
      home.username = username;
      programs.home-manager.enable = true;
      systemd.user.startServices = true;
      
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
        
        importKeys = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
        ''
          $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/public.gpg $VERBOSE_ARG && $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/private.gpg $VERBOSE_ARG
          $DRY_RUN_CMD sudo rm -rf ~/.ssh && $DRY_RUN_CMD cp ${inputs.secrets}/ssh ~/.ssh -r $VERBOSE_ARG && $DRY_RUN_CMD chmod 600 ~/.ssh && $DRY_RUN_CMD ssh-add
        '';
      };
    };
  };
}
