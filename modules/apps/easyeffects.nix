## EasyEffects Configuration ##
{
  flake.modules.homeManager.easyeffects = {pkgs, ...}: {
    services.easyeffects.enable = true;
    home = {
      file.".local/share/easyeffects" = {
        source = "${pkgs.custom.easyeffects-presets}/share/easyeffects";
        recursive = true;
      };
      persist.directories = [
        ".config/easyeffects"
        ".local/share/easyeffects"
      ];
    };
  };
}
