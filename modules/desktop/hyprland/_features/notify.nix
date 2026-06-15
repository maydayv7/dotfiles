{
  util ? null,
  files ? null,
  ...
}: {
  nixos = _: {
    # Phone Connect
    programs.kdeconnect.enable = true;
  };

  home = {
    config,
    lib,
    ...
  }: let
    inherit (lib) mkDefault;
  in {
    home.persist.directories = [".config/kdeconnect"];
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Notifications Daemon
    stylix.targets.swaync.enable = false;
    services.swaync = {
      enable = true;
      style = util.build.theme {
        inherit (config.stylix) fonts;
        inherit (config.lib.stylix) colors;
        file = files.swaync;
      };

      settings = {
        # Notification
        positionX = mkDefault "right";
        positionY = mkDefault "top";
        layer = "overlay";
        layer-shell = true;
        cssPriority = "user";

        image-visibility = "when-available";
        timeout = 10;
        timeout-critical = 0;
        timeout-low = 5;
        notification-2fa-action = true;
        notification-grouping = true;
        notification-inline-replies = true;

        # Control Center
        control-center-layer = "top";
        fit-to-screen = false;
        control-center-height = -1;
        control-center-margin-top = 3;
        control-center-margin-left = 3;
        control-center-margin-bottom = 3;
        control-center-margin-right = 3;

        widgets = [
          "inhibitors"
          "title"
          "dnd"
          "notifications"
        ];

        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          dnd.text = "Do Not Disturb";
        };

        notification-visibility = {
          utility = {
            app-name = "utility";
            state = "transient";
          };
          upower = {
            app-name = "poweralertd";
            state = "transient";
          };
          hyprland = {
            app-name = "grimblast";
            state = "transient";
          };
        };
      };
    };
  };
}
