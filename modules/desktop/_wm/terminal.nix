## Terminal Emulator
{files, ...}: {
  home = {
    config,
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

      diffConfig.settings = let
        colors = config.lib.stylix.colors;
        blend = color: percent:
          "#"
          + lib.concatMapStrings (
            channel: let
              accent = lib.toInt colors."${color}-rgb-${channel}";
              background = lib.toInt colors."base00-rgb-${channel}";
              mixed = builtins.div (accent * percent + background * (100 - percent)) 100;
            in
              lib.fixedWidthString 2 "0" (lib.toHexString mixed)
          ) ["r" "g" "b"];
        palette = with colors.withHashtag; {
          pygments_style = "catppuccin-${config.catppuccin.flavor}";
          foreground = base05;
          background = base00;
          title_fg = base0D;
          title_bg = base01;
          margin_fg = base04;
          margin_bg = base00;
          removed_bg = blend "base08" 20;
          highlight_removed_bg = blend "base08" 40;
          removed_margin_bg = blend "base08" 40;
          added_bg = blend "base0B" 20;
          highlight_added_bg = blend "base0B" 40;
          added_margin_bg = blend "base0B" 40;
          moved_bg = blend "base0A" 20;
          moved_margin_bg = blend "base0A" 40;
          filler_bg = base01;
          margin_filler_bg = base01;
          hunk_bg = blend "base0D" 20;
          hunk_margin_bg = blend "base0D" 40;
          search_fg = base00;
          search_bg = base0A;
          select_fg = base05;
          select_bg = base02;
        };
      in
        palette // lib.mapAttrs' (name: value: lib.nameValuePair "dark_${name}" value) palette;
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
