## Terminal Emulator
_: {
  home = {
    pkgs,
    lib,
    ...
  }: {
    programs.kitty = {
      enable = true;
      themeFile = lib.mkDefault "Catppuccin-Macchiato";
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "kitty_mod+f" = "launch --allow-remote-control kitty +kitten search/search.py @active-kitty-window-id";
      };

      settings = {
        allow_remote_control = "password";
        remote_control_password = ''"" get-text'';

        kitty_mod = "ctrl+shift";
        confirm_os_window_close = 2;
        copy_on_select = "clipboard";
        placement_strategy = "center";
        scrollback_lines = 10000;
        enable_audio_bell = "no";
        visual_bell_duration = "0.1";

        background_blur = 1;
        cursor_shape = "beam";
        cursor_shape_unfocused = "underline";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        window_padding_width = 10;
      };
    };

    home.file.".config/kitty/search".source = pkgs.custom.kitty-search;
  };
}
