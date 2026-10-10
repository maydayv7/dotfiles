## Wine Configuration ##
_: {
  flake.modules = {
    nixos.wine = {
      config,
      lib,
      pkgs,
      ...
    }: let
      pkg = config.apps.wine;
    in {
      options.apps.wine = lib.mkOption {
        description = "Package to use for 'wine'";
        type = lib.types.package;
        default = pkgs.wineWow64Packages.stagingFull;
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
              then name.override {wine = pkg;}
              else name
          )
          [
            pkg
            winetricks
            playonlinux
          ]
        );
      };
    };

    homeManager.wine = _: {
      home.persist.directories = [
        ".wine"
        ".cache/wine"
        ".cache/winetricks"
      ];
    };
  };
}
