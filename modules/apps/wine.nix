{
  config,
  lib,
  util,
  inputs,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues elem map;
  inherit (lib) mkIf mkEnableOption mkOption optionals types;
  cfg = config.apps.wine;
  enable = elem "wine" config.apps.list;
in {
  options.apps.wine = {
    utilities = mkEnableOption "Install Utility Windows apps";
    package = mkOption {
      description = "Package to use for 'wine'";
      type = types.package;
      default = pkgs.winePackages.stable;
      example = pkgs.gaming.wine-tkg;
    };
  };

  ## Wine Configuration ##
  config = mkIf enable {
    # Firmware
    services.samba.enable = true;
    hardware.xpadneo.enable = true;
    hardware.opengl.driSupport32Bit = true;

    # Utilities
    user.persist.directories =
      [".wine" ".cache/wine" ".cache/winetricks"]
      ++ optionals cfg.utilities [".config/notepad++"];

    environment.systemPackages = with pkgs.wine // pkgs; (
      map (name:
        if (name.override.__functionArgs ? wine)
        then name.override {wine = cfg.package;}
        else name) ([
          cfg.package
          winetricks
          mkwindowsapp-tools
          playonlinux
        ]
        ++ optionals cfg.utilities ([notepad-plus-plus]
          # Wrapped Packages
          ++ (attrValues (util.map.modules ../../packages/wine
            (name:
              callPackage name {
                inherit lib pkgs;
                wine = cfg.package;
                build = inputs.windows.lib."${pkgs.system}";
              })))))
    );
  };
}
