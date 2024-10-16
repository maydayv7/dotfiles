{
  config,
  lib,
  util,
  inputs,
  files,
  ...
}: let
  inherit (util.map) modules;
  inherit (builtins) all attrNames attrValues mapAttrs pathExists;
  inherit
    (lib)
    filterAttrs
    findFirst
    findSingle
    getValues
    mkIf
    mkEnableOption
    mkOption
    mkOptionType
    optionals
    types
    ;

  inherit (config.user) groups homeConfig settings;

  # Merged Sets Type
  mergedAttrs = mkOptionType {
    name = "mergedAttrs";
    merge = _: getValues;
  };
in {
  ## USER Configuration ##
  imports = modules.list ./. ++ [inputs.home-manager.nixosModules.home-manager];

  options = {
    # Global Home Manager Configuration
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules =
          if (all (value: value.minimal) (attrValues settings))
          then [{home.stateVersion = config.system.stateVersion;}]
          else homeConfig;
      });
    };

    # Configuration Options
    user = {
      homeConfig = mkOption {
        description = "Shared User Home Configuration";
        type = mergedAttrs;
        default = {};
      };

      groups = mkOption {
        description = "Additional User Groups";
        type = types.listOf types.str;
        default = [];
      };

      settings = mkOption {
        description = "User Settings";
        default = {};
        type = with types;
          attrsOf (submodule ({
            options,
            config,
            ...
          }: {
            freeformType = attrsOf anything;
            options = {
              forwarded = mkOption {};
              autologin = mkEnableOption "Enable Automatic User Login";
              minimal = mkEnableOption "Enable Minimal User Configuration";
              extraGroups = mkOption {
                apply = group: group ++ optionals config.isNormalUser groups;
              };
              shells = mkOption {
                description = "List of Additional Supported Shells";
                type = listOf (enum (modules.name ../shell));
                default = ["bash"];
              };
              homeConfig = mkOption {
                description = "User Specific Home Configuration";
                type = mergedAttrs;
                default = {};
              };
            };

            config = {
              isNormalUser = true;
              group = "users";
              useDefaultShell = false;
              homeConfig = let
                path = ../../. + "/users/${config.name}";
              in
                if (pathExists (path + "/default.nix"))
                then {
                  imports = [path];
                }
                else if (pathExists (path + ".nix"))
                then {
                  imports = [(path + ".nix")];
                }
                else {};

              forwarded =
                filterAttrs
                (name: _: !(options ? "${name}") || name == "extraGroups")
                config;
            };
          }));
      };
    };
  };

  config = {
    # Settings
    users = {
      mutableUsers = false;
      users = mapAttrs (_: name: name.forwarded) settings;
      extraUsers.root = {
        isNormalUser = false;
        extraGroups = ["wheel"];
      };
    };

    # Login
    services.displayManager.autoLogin = let
      find =
        findSingle (value: value.autologin || value.minimal) "0" "1"
        (attrValues settings);
    in rec {
      enable =
        if (find == "0")
        then false
        else if (config.services.displayManager.defaultSession == null)
        then throw "Graphical Environment must be present for Automatic Log-In"
        else if (find == "1")
        then throw "Only one User can be Automatically Logged-In"
        else true;

      user =
        mkIf enable
        (findFirst (name: with settings."${name}"; autologin || minimal) "nixos"
          (attrNames settings));
    };

    # Home Management
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      users = mapAttrs (_: value: {imports = value.homeConfig;}) settings;
      extraSpecialArgs = {
        inherit util inputs files;
        sys = config;
      };
    };

    # Debug
    specialisation.recovery.configuration.home-manager.verbose = true;
  };
}
