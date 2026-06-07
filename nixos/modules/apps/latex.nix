## LaTeX Configuration ##
{ config, ... }:
let
  util = config.util;
in
{
  flake.modules = {
    nixos.latex =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          texliveFull
          setzer
        ];
      };

    homeManager.latex = { ... }: {
      home.persist.directories = [ ".config/setzer" ];
      xdg.mimeApps.defaultApplications = util.build.mime {
        latex = [ "org.cvfosammmm.Setzer.desktop" ];
      };
    };
  };
}
