## LaTeX Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules = {
    nixos.latex = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        texliveFull
        setzer
      ];
    };

    homeManager.latex = _: {
      home.persist.directories = [".config/setzer"];
      xdg.mimeApps.defaultApplications = util.build.mime {
        latex = ["org.cvfosammmm.Setzer.desktop"];
      };
    };
  };
}
