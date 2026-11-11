## Terminal Emulator
{files, ...}: {
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
        "kitty_mod+slash" = "command_palette";
        "kitty_mod+f" = "launch --allow-remote-control kitty +kitten search/search.py @active-kitty-window-id";
      };

      settings = {
        kitty_mod = "ctrl+shift";
        confirm_os_window_close = 2;
        remember_window_size = "no";

        copy_on_select = "clipboard";
        placement_strategy = "center";
        scrollback_lines = 10000;

        enable_audio_bell = "yes";
        visual_bell_duration = "0.2";
        notify_on_cmd_finish = "unfocused 5.0 notify-bell focus";

        allow_remote_control = "password";
        remote_control_password = ''"" get-text'';

        background_blur = 1;
        cursor_shape = "beam";
        cursor_shape_unfocused = "underline";
        tab_bar_style = "custom";
        tab_bar_align = "center";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
        window_padding_width = 10;
      };
    };

    home.file = {
      ".config/kitty/search".source = pkgs.custom.kitty-search;
      ".config/kitty/tab_bar.py".source = files.kitty.tabs;
    };

    programs.git.settings.alias.d = lib.mkForce (lib.removeSuffix "\n" ''
      !f() {
        cd -- "''${GIT_PREFIX:-.}" || return
        if [ -n "''${KITTY_WINDOW_ID:-}" ] && [ -t 0 ] && [ -t 1 ] && command -v kitten >/dev/null 2>&1
        then
          git -c 'difftool.kitty.cmd=kitten diff "$LOCAL" "$REMOTE"' difftool --tool=kitty --dir-diff --no-symlinks --no-prompt "$@"
        else
          git diff "$@"
        fi
      }; f
    '');
  };
}
