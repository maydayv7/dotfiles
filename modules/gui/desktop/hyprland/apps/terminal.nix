{
  pkgs,
  theme,
  ...
}:
{
  ## Terminal Configuration
  user.homeConfig = {
    programs.kitty = {
      enable = true;
      themeFile = with theme; "${name-alt}-${variant-alt}";
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "kitty_mod+f" =
          "launch --allow-remote-control kitty +kitten search/search.py @active-kitty-window-id";
      };

      settings = {
        kitty_mod = "ctrl+shift";
        confirm_os_window_close = 2;
        copy_on_select = "clipboard";
        placement_strategy = "center";
        scrollback_lines = 10000;
        enable_audio_bell = "no";
        visual_bell_duration = "0.1";

        cursor_shape = "beam";
        cursor_shape_unfocused = "underline";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        window_padding_width = 10;
      };
    };

    home.file.".config/kitty/search".source = pkgs.custom.kitty-search;
    wayland.windowManager.hyprland.settings.misc.swallow_regex = "^(kitty)$";
    stylix.targets.kitty = {
      enable = true;
      variant256Colors = true;
    };
  };
}
