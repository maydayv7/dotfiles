{
  lib,
  pkgs,
  ...
}: {
  imports = lib.util.map.module ./.;

  ## Base Configuration ##
  config = {
    # Documentation
    environment = {
      enableDebugInfo = true;
      systemPackages = [pkgs.man-pages];
    };

    documentation = {
      dev.enable = true;
      man.enable = true;
    };
  };
}
