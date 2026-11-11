## PDF and Scanning Utilities ##
{
  flake.modules.homeManager.pdf = {pkgs, ...}: {
    home.packages = with pkgs; [
      gscan2pdf
      pdfarranger
      simple-scan
      xournalpp
    ];
    home.persist.files = [".config/gscan2pdfrc"];
  };
}
