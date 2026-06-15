_: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    gvariant
    mkForce
    ;
in {
  services = {
    # Session
    desktopManager.gnome.enable = true;
    displayManager = {
      defaultSession = "gnome";
      gdm.enable = true;
    };

    # Initial Setup
    gnome.gnome-initial-setup.enable = mkForce false;
  };

  # Excluded Packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-music
    showtime
  ];

  # Dconf Settings
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        "org/gnome/desktop/interface" = {
          cursor-theme = config.stylix.cursor.name;
          cursor-size = gvariant.mkInt32 config.stylix.cursor.size;
        };
      };
    }
  ];
}
