{ config, lib, pkgs, ... }:
let
  inherit (builtins) attrValues elem map;
  inherit (lib) mkIf mkOption types util;
  enable = elem "wine" config.apps.list;
  wine = config.apps.wine.package;
  wrap = import ./wrapper.nix {
    inherit pkgs;
    version = wine;
  };
in {
  options.apps.wine.package = mkOption {
    description = "Package to use for 'wine'";
    type = types.package;
    default = pkgs.wineWowPackages.stable;
    example = pkgs.gaming.wine-tkg;
  };

  ## Wine Configuration ##
  config = mkIf enable {
    # Firmware
    services.samba.enable = true;
    hardware.opengl.driSupport32Bit = true;

    # Utilities
    user.persist.dirs =
      [ ".cache/lutris" ".config/lutris" ".local/share/lutris" ".wine" ];

    environment.systemPackages = with pkgs;
      map (name:
        if (name.override.__functionArgs ? wine) then
          name.override { inherit wine; }
        else
          name) [
            lutris
            playonlinux
          ]

          # Wrapped Packages
      ++ attrValues (util.map.modules ../../../packages/wine
        (name: pkgs.callPackage name { inherit wrap pkgs; }));
  };
}
