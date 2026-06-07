{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) concatStringsSep elem map;
  inherit (config._shared) enable theme;
  inherit (theme) name variant accent;
  exists = app: elem app config.apps.list;
in
{
  ## 3rd Party Apps Configuration
  config = mkIf enable {
    apps = {
      # Logseq Notes
      logseq.style = "url('https://logseq.${name}.com/ctp-${variant}.css')";

      # YouTube Music
      ytmusic.style = "@import url('https://youtubemusic.${name}.com/src/${variant}.css');";
    };

    user.homeConfig = {
      # Theme
      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      catppuccin = {
        inherit accent;
        flavor = variant;

        brave.enable = exists "office";
        obs.enable = exists "office";
        thunderbird.enable = exists "office";
        vesktop.enable = exists "discord";
        vscode.profiles.default.enable = exists "vscode";
      };

      # Code Editor
      programs.vscode.profiles.default = mkIf (exists "vscode") {
        extensions = [ pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons ];
        userSettings = {
          "workbench.iconTheme" = "${name}-${variant}";
          "terminal.external.linuxExec" = "kitty";
        };
      };

      # KDE Apps
      home.file = {
        ".config/kwalletrc".text = ''
          [Wallet]
          Enabled=false
        '';

        ".config/kdeglobals".text =
          with config.lib.stylix.colors;
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
