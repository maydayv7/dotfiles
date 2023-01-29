{self, ...} @ inputs:
with inputs; let
  ## Variable Declaration ##
  # Supported Architectures
  platforms = ["x86_64-linux"];

  # NixOS Version
  version = readFile ./.version;

  # System Libraries
  inherit (self) files;
  inherit (lib) eachSystem filters;
  inherit (builtins) head readFile;
  inherit (lib.util) build map pack;
  lib = library.lib.extend (final: prev:
    {
      inherit (flatpak.lib) flatpak;
      deploy = deploy.lib;
      filters = ignore.lib // {inherit (filter.lib) filter matchExt;};
      hooks = hooks.lib;
      image = generators.nixosGenerate;
      wine = wine.lib;
      util = import ./lib {
        inherit self platforms;
        lib = final;
      };
    }
    // home.lib
    // utils.lib);
in
  eachSystem platforms (system: let
    # Default Package Channel
    pkgs = self.legacyPackages."${system}";

    # Package Calling Function
    call = name: pkgs.callPackage name {inherit lib inputs pkgs files;};
  in {
    ## Configuration Checks ##
    checks = import ./modules/nix/checks.nix {inherit self system lib;};

    ## Developer Shells ##
    devShells =
      map.modules' ./shells (file: pkgs.mkShell (import file pkgs))
      // {
        default = import ./shells {inherit pkgs;};
        website = import ./site/shell.nix {inherit pkgs;};
        commit =
          pkgs.mkShell {inherit (self.checks."${system}".commit) shellHook;};
      };

    ## Code Formatter ##
    formatter = pkgs.treefmt;

    ## Package Configuration ##
    legacyPackages = self.channels."${system}".stable;

    # Channels
    channels = {
      stable = (build.channel stable [] ./packages/patches)."${system}";
      unstable = (build.channel unstable [nur.overlay] [])."${system}";
      wine = wine.packages."${system}";
      gaming = gaming.packages."${system}";
      apps = {
        deploy = deploy.defaultPackage."${system}";
        generators = generators.defaultPackage."${system}";
      };
    };

    # Custom Packages
    apps = map.modules ./scripts (name: lib.mkApp {drv = call name;}) // {default = self.apps."${system}".nixos;};
    packages = map.modules ./packages call // map.modules ./scripts call // {default = self.packages."${system}".dotfiles;};
  })
  // {
    # Overrides
    overlays = map.modules ./packages/overlays import;

    ## Custom Library Functions ##
    lib = lib.util;

    ## Program Configuration and 'dotfiles' ##
    files = import ./files lib self.legacyPackages."${head platforms}";

    ## Custom Configuration Modules ##
    nixosModules =
      map.modules ./modules import
      // {default = import ./modules {inherit version lib inputs files;};};

    ## Configuration Templates ##
    templates = import ./.templates lib;

    ## Device Configuration ##
    deploy = import ./modules/nix/deploy.nix {inherit self lib;};
    nixosConfigurations =
      map.modules ./devices (name: build.device (import name));

    ## Virtual Machines ##
    vmConfigurations =
      map.modules ./devices/vm (name:
        import name (head platforms) inputs self.channels."${head platforms}".stable);

    ## Install Media Configuration ##
    installMedia = {
      # GNOME Desktop
      gnome = build.iso {
        timezone = "Asia/Kolkata";
        locale = "en_IN.UTF-8";
        kernel = "zfs";
        gui.desktop = "gnome";
      };

      # XFCE Desktop
      xfce = build.iso {
        timezone = "Asia/Kolkata";
        locale = "en_IN.UTF-8";
        kernel = "zfs";
        gui.desktop = "xfce";
      };
    };
  }
