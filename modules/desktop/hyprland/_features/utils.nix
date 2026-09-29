## Utilities
{files ? null, ...}: {
  nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      custom.hyprutils
      unstable.pyprland
      hyprshade
    ];
  };

  home = _: {
    home.file = with files.hyprland; {
      # Pyprland
      ".config/pypr/config.toml".text = pypr;

      # Shaders
      ".config/hypr/shaders" = {
        source = shaders;
        recursive = true;
      };
    };
  };
}
