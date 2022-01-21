{ config, lib, inputs, ... }:
let
  inherit (config) user;
  inherit (inputs.home.nixosModules) home-manager;
  inherit (builtins) attrNames attrValues concatStringsSep mapAttrs;
  inherit (lib)
    filterAttrs genAttrs intersectLists mkDefault mkIf mkOption types util;
in rec {
  imports = [ home-manager ./home ./recovery.nix ./security.nix ];

  # Configuration Options
  options = {
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith { modules = user.home; });
    };

    user = {
      home = mkOption {
        description = "Alias for 'home-manager.users.$username'";
        type = util.types.mergedAttrs;
        default = { };
      };

      groups = mkOption {
        description = "Additional User Groups";
        type = types.listOf types.str;
        default = [ ];
      };

      settings = mkOption {
        description = "Alias for 'users.users.$username'";
        default = { };
        type = with types;
          attrsOf (submodule ({ options, config, ... }: {
            freeformType = attrsOf anything;
            options = {
              forwarded = mkOption { };
              extraGroups = mkOption {
                apply = groups:
                  if config.isNormalUser then user.groups ++ groups else groups;
              };
              homeConfig = mkOption {
                description = "User Specific 'home-manager' Configuration";
                type = util.types.mergedAttrs;
                default = { };
              };
            };

            config = {
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
    # User Settings
    users = {
      mutableUsers = false;
      users = mapAttrs (_: name: name.forwarded) user.settings;
      extraUsers.root = {
        isNormalUser = false;
        extraGroups = [ "wheel" ];
      };
    };

    # Home Manager Settings
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      users = mapAttrs (_: name: { imports = name.homeConfig; }) user.settings;
    };
  };
}
