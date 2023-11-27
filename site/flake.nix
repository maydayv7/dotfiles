_: {
  ## Website Configuration ##
  perSystem = {pkgs, ...}: {
    # Package
    packages.website = pkgs.callPackage ./. {inherit pkgs;};

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
