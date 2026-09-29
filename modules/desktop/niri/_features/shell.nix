## Shell Integration
_: {
  home = {config, ...}: {
    programs.noctalia.settings = {
      shell.niri_overview_type_to_launch_enabled = true;
      plugin_settings."maydayv7/keyhelp".niri_path = "${config.programs.niri.package}/bin/niri";
    };
  };
}
