{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkAfter mkIf;
  enable = builtins.elem "games" config.apps.list;
  wine = builtins.elem "wine" config.apps.list;
in {
  ## Games Configuration ##
  config = mkIf enable {
    assertions = [
      {
        assertion = wine;
        message = ''
          Wine support is required
          - Add 'wine to 'apps.list'
        '';
      }
    ];

    user.persist.directories = [
      "Games"
      ".cache/lutris"
      ".config/lutris"
      ".local/share/bottles"
      ".local/share/lutris"
    ];

    # Packages
    apps.wine.package = pkgs.gaming.wine-ge;
    environment.systemPackages = with pkgs; [
      bottles
      lutris
    ];
  };
}
