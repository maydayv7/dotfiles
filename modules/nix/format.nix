{inputs, ...}: {
  ## Code Formatter ##
  imports = [inputs.formatter.flakeModule];

  perSystem = {pkgs, ...}: {
    treefmt.config = rec {
      package = pkgs.treefmt;

      projectRoot = ../../.;
      projectRootFile = "${projectRoot}/flake.nix";
      settings.global.excludes = [
        "_*"
        "result/**"
        "flake.lock"
      ];

      # Formatters
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
