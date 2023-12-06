{inputs, ...}: {
  ## Configuration Checks ##
  imports = [inputs.formatter.flakeModule];

  perSystem = {pkgs, ...}: {
    ## Code Formatter
    treefmt.config = rec {
      package = pkgs.treefmt;

      projectRoot = ../.;
      projectRootFile = "${projectRoot}/flake.nix";
      settings.global.excludes = [
        "_*"
        "result/**"
        "flake.lock"
      ];

      programs = {
        alejandra.enable = true;
        statix.enable = true;
        shellcheck.enable = false;
        stylua.enable = true;
        prettier = {
          enable = true;
          settings.bracketSameLine = true;
        };
      };
    };
  };
}
