## OBS Studio Configuration ##
{
  flake.modules = {
    nixos.obs-studio = {pkgs, ...}: {
      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-mute-filter
          obs-source-switcher
        ];
      };
    };

    homeManager.obs-studio = {
      home.persist.directories = [".config/obs-studio"];
    };
  };
}
