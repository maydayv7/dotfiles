{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (config._shared) enable theme;
in
{
  ## Text Configuration
  config = lib.mkIf enable {
    environment.systemPackages = [ pkgs.geany ];
    user.homeConfig = {
      # Text Editor
      xdg.mimeApps.defaultApplications = util.build.mime {
        markdown = [ "geany.desktop" ];
        text = [ "geany.desktop" ];
      };

      home = {
        persist.directories = [
          ".config/clipse"
          ".config/geany"
        ];

        file = with files.geany; {
          ".config/geany/geany.conf".text = settings;
          ".config/geany/keybindings.conf".text = keybindings;
          ".config/geany/colorschemes/theme.conf".source =
            with theme;
            "${pkgs.custom.geany-catppuccin}/share/geany/colorschemes/${name}-${variant}.conf";
        };
      };

      # Clipboard Manager
      services.clipse = {
        enable = true;
        allowDuplicates = false;
        historySize = 150;
        imageDisplay.type = "kitty";
        theme = with config.lib.stylix.colors; {
          useCustomTheme = true;
          DimmedDesc = "#${base07}";
          DimmedTitle = "#${base07}";
          FilteredMatch = "#${base08}";
          NormalTitle = "#${base08}";
          NormalDesc = "#${base0B}";
          SelectedDesc = "#${base0D}";
          SelectedTitle = "#${base0D}";
          SelectedBorder = "#${base0D}";
          SelectedDescBorder = "#${base0D}";
          TitleFore = "#${base05}";
          Titleback = "#${base01}";
          StatusMsg = "#${base0E}";
          PinIndicatorColor = "#${base0F}";
        };
      };
    };
  };
}
