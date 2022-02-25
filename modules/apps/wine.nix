{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues elem map;
  inherit (lib) mkIf mkOption types util;
  enable = elem "wine" config.apps.list;
  wine = config.apps.wine.package;
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
    user.persist.dirs = [
      ".cache/lutris"
      ".config/lutris"
      ".config/notepad++"
      ".local/share/lutris"
      ".wine"
    ];

    environment.systemPackages = with pkgs.wine // pkgs;
      map (name:
        if (name.override.__functionArgs ? wine)
        then name.override {inherit wine;}
        else name) [
        lutris
        playonlinux
        mkwindowsapp-tools
        notepad-plus-plus
      ]
      # Wrapped Packages
      ++ attrValues (util.map.modules ../../packages/wine
      (name: pkgs.callPackage name {inherit lib pkgs wine;}));
  };
}
