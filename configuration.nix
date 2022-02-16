{ self, ... }@inputs:
with inputs;
let
  ## Variable Declaration ##
  # Supported Architectures
  platforms = [ "x86_64-linux" ];

  # NixOS Version
  version = readFile ./.version;

  # System Libraries
  inherit (self) files;
  inherit (builtins) readFile;
  inherit (lib) eachSystem filters;
  inherit (lib.util) build map pack;
  lib = library.lib.extend (final: prev:
    {
      deploy = deploy.lib;
      filters = ignore.lib // { inherit (filter.lib) filter matchExt; };
      hooks = hooks.lib;
      image = generators.nixosGenerate;
      wine = wine.lib;
      util = import ./lib {
        inherit self platforms;
        lib = final;
      };
    } // home.lib // utils.lib);
in eachSystem platforms (system:
  let pkgs = self.channels."${system}".stable;
  in {
    ## Configuration Checks ##
    checks = import ./modules/nix/checks.nix { inherit self system lib pkgs; };

    ## Developer Shells ##
    # Default Shell
    devShell = import ./shells { inherit pkgs; };

    # Tailored Shells
    devShells = map.modules' ./shells (file: pkgs.mkShell (import file pkgs))
      // {
        commit =
          pkgs.mkShell { inherit (self.checks."${system}".commit) shellHook; };
      };

    ## Package Configuration ##
    legacyPackages = pkgs;

    # Channels
    channels = {
      stable = (build.channel stable [ ] ./packages/patches)."${system}";
      unstable = (build.channel unstable [ nur.overlay ] [ ])."${system}";
      wine = wine.packages."${system}";
      gaming = gaming.packages."${system}";
      apps = {
        deploy = deploy.defaultPackage."${system}";
        generators = generators.defaultPackage."${system}";
      };
    };

    # Custom Packages
    defaultApp = self.apps."${system}".nixos;
    defaultPackage = self.packages."${system}".dotfiles;
    packages = map.modules ./packages
      (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
    apps = map.modules ./scripts (name:
      lib.mkApp {
        drv = pkgs.callPackage name { inherit self lib pkgs files; };
      });
  }) // {
    # Overrides
    overlays = map.modules ./packages/overlays import;

    ## Program Configuration and `dotfiles` ##
    files = import ./files { inherit lib inputs; };

    ## Custom Library Functions ##
    lib = lib.util;

    ## Custom Configuration Modules ##
    nixosModule = import ./modules { inherit version lib inputs files; };
    nixosModules = map.modules ./modules import;

    ## Configuration Templates ##
    defaultTemplate = self.templates.minimal;
    templates = {
      minimal = {
        description = "Simple, Minimal NixOS Configuration";
        path = filters.filter {
          root = ./.templates/minimal;
          include = [ (filters.matchExt "nix") ];
        };
      };
      extensive = {
        description = "My Complete, Extensive NixOS Configuration";
        path = filters.filter {
          root = ./.;
          exclude = [
            ./files/gpg
            ./.git-crypt
            ./.github
            ./.gitlab
            (filters.matchExt "md")
            (filters.matchExt "secret")
          ];
        };
      };
    };

    ## Device Configuration ##
    deploy = import ./modules/nix/deploy.nix { inherit self lib; };
    nixosConfigurations =
      map.modules ./devices (name: build.device (import name));

    ## Install Media Configuration ##
    installMedia = {
      # GNOME Desktop
      gnome = build.iso {
        timezone = "Asia/Kolkata";
        locale = "en_IN.UTF-8";
        kernel = "linux_zfs";
        gui.desktop = "gnome-minimal";
      };
    };
  }
