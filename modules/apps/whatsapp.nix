## WhatsApp Client Configuration ##
{
  flake.modules.homeManager.zapzap = {pkgs, ...}: {
    home.packages = [pkgs.zapzap];
    home.persist.directories = [
      ".config/ZapZap"
      ".local/share/ZapZap"
      ".cache/ZapZap"
    ];
  };
}
