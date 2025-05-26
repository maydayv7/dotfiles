{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    gvariant
    mkForce
    ;
in
{
  # Session
  services = {
    displayManager.defaultSession = "gnome";
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    # Initial Setup
    gnome.gnome-initial-setup.enable = mkForce false;
  };

  # Excluded Packages
  environment.gnome.excludePackages = with pkgs; [
    totem
    gnome-music
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
