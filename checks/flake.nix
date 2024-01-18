{
  config,
  inputs,
  ...
}: {
  ## Configuration Checks ##
  imports = [inputs.formatter.flakeModule];

  perSystem = {
    system,
    pkgs,
    ...
  }: {
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
        deadnix = {
          enable = true;
          no-lambda-arg = true;
        };
        prettier = {
          enable = true;
          settings.bracketSameLine = true;
          excludes = ["*.css"];
        };
      };
    };

    # Formatting Shell
    devShells.format = config.allSystems."${system}".treefmt.build.devShell;
  };
}
