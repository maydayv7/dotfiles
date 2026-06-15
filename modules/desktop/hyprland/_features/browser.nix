_: {
  home = _: {
    home.file.".config/mozilla/firefox/default/chrome/userChrome.css".text = ''
      #TabsToolbar {
        -moz-window-dragging: no-drag;
      }
    '';

    # Theme
    programs.firefox.policies.ExtensionSettings = {
      name = "catppuccin-macchiato-blue";
      value = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/{d49033ac-8969-488c-afb0-5cdb73957f41}/latest.xpi";
      };
    };
  };
}
