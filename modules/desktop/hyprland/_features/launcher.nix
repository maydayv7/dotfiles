{
  util ? null,
  files ? null,
  inputs ? null,
  ...
}: {
  home = {config, ...}: {
    imports = [inputs.hyprshell.homeModules.default];
    home.persist.directories = [
      ".local/share/hyprshell"
      ".cache/hyprshell"
    ];

    programs.hyprshell = {
      enable = true;
      systemd.enable = true;
      styleFile = util.build.theme {
        inherit (config.lib.stylix) colors;
        file = files.hyprland.hyprshell;
      };

      settings.windows = {
        enable = true;
        scale = 9.0;
        items_per_row = 3;

        overview = {
          enable = true;
          modifier = "super";
          key = "tab";

          launcher = {
            launch_modifier = "alt";
            default_terminal = "kitty";
            width = 700;
            max_items = 4;
            show_when_empty = true;
            plugins = {
              applications = {
                run_cache_weeks = 4;
                show_execs = true;
                show_actions_submenu = true;
              };
              calc.enable = true;
              path.enable = true;
              terminal.enable = true;
              websearch.engines = [
                {
                  url = "https://www.google.com/search?q={}";
                  name = "Google";
                  key = "g";
                }
                {
                  url = "https://en.wikipedia.org/wiki/Special:Search?search={}";
                  name = "Wikipedia";
                  key = "w";
                }
              ];
            };
          };
        };

        switch = {
          enable = true;
          modifier = "alt";
          filter_by = ["current_workspace"];
        };

        switch_2 = {
          enable = true;
          modifier = "alt";
          key = "grave";
          filter_by = ["same_class"];
        };
      };
    };
  };
}
