{ self, ... }@inputs:
with inputs;
let
  ## Variable Declaration ##
  # Supported Architectures
  systems = [ "x86_64-linux" ];

  # NixOS Version
  version = readFile ./.version;

  # System Libraries
  inherit (self) files;
  inherit (builtins) readFile;
  inherit (lib.util) build map pack;
  lib = nixpkgs.lib.extend (final: prev:
    {
      hooks = hooks.lib;
      image = generators.nixosGenerate;
      util = import ./lib {
        inherit self systems;
        lib = final;
      };
    } // home.lib // utils.lib);
in lib.eachSystem systems (system:
  let
    # Package Channels
    overlays = [ nur.overlay wayland.overlay ];
    pkgs = (build.channel nixpkgs overlays ./packages/patches)."${system}";
    pkgs' = (build.channel unstable overlays [ ])."${system}";
  in {
    ## Configuration Checks ##
    checks = import ./modules/nix/checks.nix { inherit self system lib pkgs; };

    ## Developer Shells ##
    # Default Shell
    devShell = import ./shells { inherit pkgs; };

    # Tailored Shells
    devShells = map.modules' ./shells (file: pkgs.mkShell (import file pkgs));

    ## Package Configuration ##
    legacyPackages = self.channels."${system}".stable;
    channels = {
      stable = pkgs;
      unstable = pkgs';
      gaming = gaming.packages."${system}";
    };

    # Custom Packages
    defaultApp = self.apps."${system}".nixos;
    defaultPackage = self.packages."${system}".dotfiles;
    apps = map.modules ./scripts
      (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
    packages = self.apps."${system}" // map.modules ./packages
      (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
  }) // {
    # Overrides
    overlays = map.modules ./packages/overlays import;

    ## Program Configuration and `dotfiles` ##
    files = import ./files { inherit lib; };

    ## Custom Library Functions ##
    lib = lib.util;

    ## Custom Configuration Modules ##
    nixosModule = import ./modules { inherit version lib inputs files; };
    nixosModules = map.modules ./modules import // {
      secrets = import ./secrets;
    };

    ## Configuration Templates ##
    defaultTemplate = self.templates.minimal;
    templates = {
      extensive = {
        path = ./.;
        description = "My Complete, Extensive NixOS Configuration";
      };
      minimal = {
        path = ./.templates/minimal;
        description = "Simple, Minimal NixOS Configuration";
      };
    };

    ## Device Configuration ##
    nixosConfigurations =
      map.modules ./devices (name: build.device (import name));

    ## Install Media Configuration ##
    installMedia = {
      # GNOME Desktop
      gnome = build.iso {
        timezone = "Asia/Kolkata";
        locale = "en_IN.UTF-8";
        kernel = "linux_5_15";
        desktop = "gnome-minimal";
      };
    };
  }
