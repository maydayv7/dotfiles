{
  util,
  pkgs,
  ...
}: {
  imports = util.map.module ./.;

  ## Base Configuration ##
  config.documentation.nixos.enable = false;
}
