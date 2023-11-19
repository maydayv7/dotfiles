{
  config,
  util,
  ...
}: {
  ## Developer Shells ##
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    devShells =
      util.map.modules' ./. (file: pkgs.mkShell (import file pkgs))
      // {
        default = import ./. {inherit pkgs;};
        website = import ../site/shell.nix {inherit pkgs;};
        format = config.allSystems."${system}".treefmt.build.devShell;
      };
  };
}
