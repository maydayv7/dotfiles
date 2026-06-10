{
  util ? null,
  files ? null,
  ...
}: {
  config,
  pkgs,
  ...
}: {
  ## Launcher Configuration
  user.homeConfig = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      configPath = ".config/rofi/main.rasi";
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];
    };

    stylix.targets.rofi.enable = true;
    home = {
      persist.directories = [".cache/rofi"];
      file.".config/rofi/config.rasi".text = util.build.theme {
        inherit (config.lib.stylix) colors;
        file = files.niri.rofi;
      };
    };
  };
}
