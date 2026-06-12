# 3rd party app theming (catppuccin) + KDE apps
{
  inputs ? null,
  theme ? null,
  ...
}: {
  home = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (builtins) concatStringsSep map;
    inherit (theme) name variant accent;
  in {
    imports = [inputs.catppuccin.homeModules.catppuccin];

    config =
      {
        # Theme
        catppuccin = {
          inherit accent;
          flavor = variant;

          brave.enable = true;
          thunderbird.enable = true;
          obs.enable = config.programs.obs-studio.enable or false;
          vesktop.enable = config.programs.nixcord.vesktop.enable or false;
          vscode.profiles.default.enable = config.programs.vscode.enable or false;
        };

        # KDE Apps
        home.file = {
          ".config/kwalletrc".text = ''
            [Wallet]
            Enabled=false
          '';

          ".config/kdeglobals".text = with config.lib.stylix.colors;
            ''
              [Colors:Selection]
              BackgroundNormal=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
              BackgroundAlternate=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
              ForegroundNormal=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
              ForegroundActive=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
              ForegroundInactive=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
              ForegroundLink=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
              ForegroundVisited=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
            ''
            + (concatStringsSep "\n" (
              map
              (name: ''
                [Colors:${name}]
                BackgroundNormal=${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}
                BackgroundAlternate=${base01-rgb-r},${base01-rgb-g},${base01-rgb-b}
                DecorationFocus=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
                DecorationHover=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
                ForegroundNormal=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
                ForegroundActive=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
                ForegroundInactive =${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
                ForegroundLink=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
                ForegroundVisited=${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}
                ForegroundNegative=${base08-rgb-r},${base08-rgb-g},${base08-rgb-b}
                ForegroundNeutral=${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}
                ForegroundPositive=${base0B-rgb-r},${base0B-rgb-g},${base0B-rgb-b}
              '')
              [
                "View"
                "Window"
                "Button"
                "Tooltip"
                "Complementary"
              ]
            ));
        };
      };
  };
}
