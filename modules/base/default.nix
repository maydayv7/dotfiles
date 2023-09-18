{
  lib,
  pkgs,
  ...
}: {
  imports = lib.util.map.module ./.;

  ## Base Configuration ##
  config.documentation.nixos.enable = false;
}
