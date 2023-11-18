{util, ...}: let
  inherit (util) map;
in {
  ## Developer Shells ##
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    devShells =
      map.modules' ./. (file: pkgs.mkShell (import file pkgs))
      // {
        default = import ./. {inherit pkgs;};
        website = import ../site/shell.nix {inherit pkgs;};
        commit =
          pkgs.mkShell {inherit (self'.checks.commit) shellHook;};
      };
  };
}
