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
    packages.stagit = pkgs.callPackage ./git/stagit {};
    apps.gitsite = {
      type = "app";
      program = lib.getExe (pkgs.callPackage ./git {inherit lib pkgs;});
    };

    # Development Shell
    devShells.website = import ./shell.nix {inherit pkgs;};

    # Formatting Errors
    treefmt.config.programs.prettier.excludes = [
      "site/templates/macros/javascript.html"
      "site/templates/macros/menu.html"
    ];
  };
}
