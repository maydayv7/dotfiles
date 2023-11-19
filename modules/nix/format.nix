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

          # Formatting Errors
          excludes = [
            "site/templates/macros/edit.html"
            "site/templates/macros/head.html"
            "site/templates/macros/javascript.html"
            "site/templates/macros/menu.html"
            "site/templates/macros/posts.html"
            "site/templates/tags/list.html"
          ];
        };
      };
    };
  };
}
