{ config, options, lib, ... }:
let
  inherit (lib) mkIf mkOption mkAliasDefinitions types;
  cfg = config.user;
  opt = options.user;
in rec {
  imports = [ ./home.nix ./recovery.nix ./security.nix ];

  options.user = {
    # User Creation
    name = mkOption {
      description = "Name of User";
      type = types.str;
      readOnly = true;
    };

    description = mkOption {
      description = "User Description";
      type = types.str;
      default = "";
    };

    groups = mkOption {
      description = "User Description";
      type = types.listOf types.str;
      default = [ "wheel" ];
    };

    uid = mkOption {
      description = "User ID";
      type = types.int;
      default = 1000;
    };

    password = mkOption {
      description = "Hashed User Password";
      type = types.str;
      default = "";
    };

    autologin = mkOption {
      description = "Enable User Auto-Login";
      type = types.bool;
      default = false;
    };

    # Configuration Options
    settings = mkOption {
      description = "Alias for users.users.$username";
      type = types.attrs;
      default = { };
    };

    home = mkOption {
      description = "Alias for home-manager.users.$username";
      type = types.attrs;
      default = { };
    };
  };

  ## User Configuration ##
  config = {
    users.mutableUsers = mkIf (cfg.password == "") false;
    security.sudo.wheelNeedsPassword = mkIf (cfg.password == "") false;

    # Configuration Options
    users.users."${cfg.name}" = mkAliasDefinitions opt.settings;
    home-manager.users."${cfg.name}" = mkAliasDefinitions opt.home;

    # Home Manager Settings
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };

    # User Creation
    user.settings = {
      # Profile
      name = cfg.name;
      description = cfg.description;
      isNormalUser = true;
      uid = cfg.uid;
      initialHashedPassword = cfg.password;

      # Groups
      group = "users";
      extraGroups = cfg.groups;

      # Shell
      useDefaultShell = if opt ? shell then false else true;
    };

    # User Login
    services.xserver.displayManager.autoLogin = {
      enable = cfg.autologin;
      user = cfg.name;
    };
  };
}
