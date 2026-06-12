## Wine Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules = {
    nixos.wine = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit (builtins) attrValues map;
      inherit
        (lib)
        mkEnableOption
        mkOption
        optionals
        types
        ;
      cfg = config.apps.wine;
    in {
      options.apps.wine = {
        utilities = mkEnableOption "Install Utility Windows apps";
        package = mkOption {
          description = "Package to use for 'wine'";
          type = types.package;
          default = pkgs.wineWow64Packages.stagingFull;
        };
      };

      config = {
        services.samba.enable = true;
        hardware.xpadneo.enable = true;
        hardware.graphics.enable32Bit = true;

        environment.systemPackages = with pkgs.wine // pkgs; (
          map
          (
            name:
              if (name.override.__functionArgs ? wine)
              then name.override {wine = cfg.package;}
              else name
          )
          (
            [
              cfg.package
              winetricks
              mkwindowsapp-tools
              playonlinux
            ]
            # Wrapped Packages
            ++ optionals cfg.utilities (
              attrValues (
                util.map.modules ../../packages/wine (
                  name:
                    callPackage name {
                      inherit lib pkgs;
                      wine = cfg.package;
                      build = winelib;
                    }
                )
              )
            )
          )
        );
      };
    };

    homeManager.wine = {
      config,
      lib,
      ...
    }: {
      home.persist.directories =
        [
          ".wine"
          ".cache/wine"
          ".cache/winetricks"
        ]
        ++ lib.optionals (config.apps.wine.utilities or false) [".config/notepad++"];
    };
  };
}
