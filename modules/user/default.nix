{ config, lib, inputs, files, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib) filterAttrs mkIf mkEnableOption mkOption types util;
  inherit (config) user;
in rec {
  imports = [
    ./home
    ./recovery.nix
    ./security.nix
    inputs.home.nixosModules.home-manager
  ];

  # Configuration Options
  options = {
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith { modules = user.home; });
    };

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
              minimal = mkEnableOption "Enable Minimal User Configuration";
              extraGroups = mkOption {
                apply = groups:
                  if config.isNormalUser then user.groups ++ groups else groups;
              };
              homeConfig = mkOption {
                description = "User Specific Home Configuration";
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
    };

    # Home Manager Settings
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = { inherit lib inputs files; };
      users = mapAttrs (_: name: { imports = name.homeConfig; }) user.settings;
    };
  };
}
