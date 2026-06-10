## Website Configuration ##
_: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    # Website
    packages.website = pkgs.callPackage ./. {inherit lib pkgs;};

    # 'git' Frontend
    apps.build-stagit = {
      type = "app";
      program = lib.getExe (pkgs.callPackage ./git {inherit lib pkgs;});
    };

    # Development Shell
    devShells.website = import ./shell.nix {inherit pkgs;};

    # Formatting Errors
    treefmt.config.programs.prettier.excludes = [
      "site/templates/macros/edit.html"
      "site/templates/macros/head.html"
      "site/templates/macros/javascript.html"
      "site/templates/macros/menu.html"
      "site/templates/macros/posts.html"
      "site/templates/tags/list.html"
    ];
  };
}
