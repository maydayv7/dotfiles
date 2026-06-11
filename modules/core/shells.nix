## Developer Shells ##
{config, ...}: let
  inherit (config) util;
in {
  perSystem = {pkgs, ...}: {
    devShells =
      util.map.modules ../../shells (file: pkgs.mkShell (import file pkgs))
      // {
        default = import ../../shells {inherit pkgs;};
      };
  };
}
