## Code Formatting & Checks ##
{inputs, ...}: {
  imports = [inputs.formatter.flakeModule];

  perSystem = {config, ...}: {
    treefmt.config = {
      projectRootFile = "flake.nix";
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
        };
        clang-format.enable = true;
        ruff-format.enable = true;
      };
    };

    devShells.format = config.treefmt.build.devShell;
  };
}
