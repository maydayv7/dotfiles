## Code formatting and checks ##
{ inputs, ... }:
{
  imports = [ inputs.formatter.flakeModule ];

  perSystem =
    { config, system, ... }:
    {
      treefmt.config = {
        projectRootFile = "flake.nix";
        settings.global.excludes = [
          "_*"
          "result/**"
          "flake.lock"
        ];

        programs = {
          nixfmt.enable = true;
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
        };
      };

      devShells.format = config.treefmt.build.devShell;
    };
}
