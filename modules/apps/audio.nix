## Audio Controls and Routing ##
{
  flake.modules.homeManager.audio = {pkgs, ...}: {
    home.packages = with pkgs; [
      pwvucontrol
      qpwgraph
    ];
    home.persist.files = [".config/rncbc.org/qpwgraph"];
  };
}
