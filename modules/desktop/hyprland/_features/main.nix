{
  util ? null,
  files ? null,
  ...
}: {
  nixos = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit
      (lib)
      getExe
      getExe'
      mkForce
      replaceStrings
      ;
  in {
    # WM
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = pkgs.hyprworld.hyprland;
      portalPackage = pkgs.hyprworld.xdg-desktop-portal-hyprland;
    };

    # Greeter
    services.greetd.settings.default_session.command = mkForce "${getExe' config.programs.hyprland.package "start-hyprland"} -- --config ${
      pkgs.writeText "greeter.conf" (
        replaceStrings ["@greeter"] [(getExe config.programs.regreet.package)] (
          util.build.theme {
            inherit (config.lib.stylix) colors;
            file = files.hyprland.greeter;
          }
        )
      )
    } &> /dev/null";

    # App Environment
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home = _: {
    home.persist.directories = [".config/hypr"];
  };
}
