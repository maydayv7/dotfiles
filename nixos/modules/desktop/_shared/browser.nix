{
  config,
  lib,
  ...
}:
let
  inherit (config._shared) enable theme;
in
{
  ## Browser Configuration
  config = lib.mkIf enable {
    apps.list = [ "firefox" ];
    user.homeConfig = {
      home.file.".mozilla/firefox/default/chrome/userChrome.css".text = ''
        #TabsToolbar {
          -moz-window-dragging: no-drag;
        }
      '';

      # Theme
      programs.firefox.policies.ExtensionSettings = {
        name = with theme; "${name}-${variant}-${accent}";
        value = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/{d49033ac-8969-488c-afb0-5cdb73957f41}/latest.xpi";
        };
      };
    };
  };
}
