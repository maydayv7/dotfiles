{ config, lib, inputs, files, ... }:
let
  inherit (builtins) all attrNames attrValues mapAttrs pathExists toPath;
  inherit (lib)
    filterAttrs findFirst findSingle mkIf mkEnableOption mkOption types util;
  inherit (config.user) groups home settings;
in {
  imports = util.map.module ./. ++ [ inputs.home.nixosModules.home-manager ];

  options = {
    # Global Home Manager Configuration
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = if (all (value: value.minimal) (attrValues settings)) then
          [ ]
        else
          home;
      });
    };

    # Configuration Options
    user = {
      home = mkOption {
        description = "User Home Configuration";
        type = util.types.mergedAttrs;
        default = { };
      };

      groups = mkOption {
        description = "Additional User Groups";
        type = types.listOf types.str;
        default = [ ];
      };

      settings = mkOption {
        description = "User Settings";
        default = { };
        type = with types;
          attrsOf (submodule ({ options, config, ... }: {
            freeformType = attrsOf anything;
            options = {
              forwarded = mkOption { };
              autologin = mkEnableOption "Enable Automatic User Login";
              minimal = mkEnableOption "Enable Minimal User Configuration";
              extraGroups = mkOption {
                apply = group:
                  if config.isNormalUser then groups ++ group else group;
              };
              shells = mkOption {
                description = "List of Additional Supported Shells";
                type = listOf (enum (util.map.module' ../shell));
                default = [ "bash" ];
              };
              recovery = mkOption {
                description = "Enable User Recovery Settings";
                type = bool;
                default = true;
              };
              homeConfig = mkOption {
                description = "User Specific Home Configuration";
                type = util.types.mergedAttrs;
                default = { };
              };
            };

            config = {
              isNormalUser = true;
              group = "users";
              useDefaultShell = false;
              homeConfig =
                let path = toPath "${../../.}" + "/users/${config.name}";
                in if (pathExists "${path}/default.nix") then {
                  imports = [ path ];
                } else if (pathExists "${path}.nix") then {
                  imports = [ "${path}.nix" ];
                } else
                  { };

              forwarded = filterAttrs
                (name: _: !(options ? "${name}") || name == "extraGroups")
                config;
            };
          }));
      };
    };
  };

  ## User Configuration ##
  config = {
    # Settings
    users = {
      mutableUsers = false;
      users = mapAttrs (_: name: name.forwarded) settings;
      extraUsers.root = {
        isNormalUser = false;
        extraGroups = [ "wheel" ];
      };
    };

    # Login
    services.xserver.displayManager.autoLogin = let
      find = findSingle (value: value.autologin || value.minimal) "0" "1"
        (attrValues settings);
    in {
      enable = if (find == "0") then
        false
      else if (find == "1") then
        throw "Only one User can be Automatically Logged-In"
      else
        true;
      user = mkIf config.services.xserver.displayManager.autoLogin.enable
        (findFirst (name: with settings."${name}"; autologin || minimal) "nixos"
          (attrNames settings));
    };

    # Home Management
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = { inherit lib inputs files; };
      users = mapAttrs (_: value: { imports = value.homeConfig; }) settings;
    };
  };
}
