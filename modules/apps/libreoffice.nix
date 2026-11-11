## LibreOffice Configuration ##
{
  flake.modules.homeManager.libreoffice = {pkgs, ...}: {
    home.packages = [pkgs.libreoffice];
    home.persist.directories = [".config/libreoffice"];
  };
}
