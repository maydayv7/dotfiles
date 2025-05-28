{
  config,
  util,
  inputs,
  files,
  ...
}:
{
  ## Launcher Configuration
  user.homeConfig = {
    imports = [ inputs.hyprshell.homeModules.hyprshell ];
    programs.hyprshell = {
      enable = true;
      systemd.enable = true;
      styleFile = util.build.theme {
        inherit (config.lib.stylix) colors;
        file = files.hyprland.hyprshell;
      };

      settings = {
        layerrules = false;

        launcher = {
          enable = true;
          default_terminal = "kitty";
          width = 700;
          max_items = 10;
          plugins = {
            applications = {
              run_cache_weeks = 4;
              show_execs = true;
            };
            websearch.engines = [
              {
                url = "https://www.google.com/search?q={}";
                name = "Google";
                key = "g";
              }
            ];
          };
        };

        windows = {
          scale = 9.0;
          workspaces_per_row = 3;
          strip_html_from_workspace_title = true;

          overview = {
            open = {
              modifier = "super";
              key = "tab";
            };
            navigate = {
              forward = "tab";
              reverse.mod = "shift";
            };
          };

          switch = {
            open.modifier = "alt";
            navigate = {
              forward = "tab";
              reverse.mod = "shift";
            };
            other = {
              hide_filtered = true;
              filter_by = [ "current_workspace" ];
            };
          };
        };
      };
    };
  };
}
