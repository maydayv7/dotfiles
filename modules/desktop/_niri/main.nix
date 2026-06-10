{
  util ? null,
  files ? null,
  inputs ? null,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
} @ args: {
  ## Niri Configuration ##
  imports = [
    (import ../_shared {inherit util files inputs;})
    inputs.niri.nixosModules.niri
  ];

  config = lib.mkIf (config.gui.desktop == "niri") (
    lib.mkMerge (
      # App Configuration
      (builtins.map (path: (import path {inherit util files inputs;}) args) (
        util.map.modules.list ./apps
      ))
      ++ [
        ## Environment Setup
        {
          programs = {
            # WM
            niri = {
              enable = true;
              package = pkgs.niri-unstable;
            };

            # Session
            uwsm = {
              enable = true;
              waylandCompositors = {
                niri = {
                  prettyName = "Niri";
                  comment = "Niri compositor managed by UWSM";
                  binPath = "/run/current-system/sw/bin/niri";
                };
              };
            };
          };

          # Settings
          _shared.enable = true;
          systemd.user.services.niri-flake-polkit.enable = false;
          user.homeConfig = {
            imports = builtins.map (
              p:
                import p {
                  inherit util files;
                  sys = config;
                }
            ) (util.map.modules.list ./settings);
            programs.niri = {inherit (config.programs.niri) package;};
          };
        }
      ]
    )
  );
}
