{
  util,
  pkgs,
  ...
}: {
  imports = util.map.module ./.;

  ## Base Configuration ##
  config = {
    # Documentation
    environment. systemPackages = [pkgs.man-pages];
    documentation = {
      dev.enable = true;
      man.enable = true;
    };
  };
}
