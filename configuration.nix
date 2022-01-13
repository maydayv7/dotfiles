{ self, ... }@inputs:
with inputs;
let
  ## Variable Declaration ##
  # Supported Architectures
  systems = nixpkgs.lib.splitString "\n" (readFile ./.systems);

  # NixOS Version
  version = readFile ./.version;

  # System Libraries
  files = self.files;
  inherit (builtins) readFile;
  inherit (lib) build map pack;
  args = { inherit args systems version lib inputs files; };
  lib = nixpkgs.lib // home.lib // utils.lib // self.lib // {
    hooks = hooks.lib;
  };
in utils.lib.eachSystem systems (system:
  let
    args' = args // { inherit system pkgs; };

    # Package Channels
    pkgs = (build.channel nixpkgs [ nur.overlay ] ./packages/patches).${system};
    pkgs' = (build.channel unstable [ nur.overlay ] [ ]).${system};
  in {
    ## Configuration Checks ##
    checks = import ./modules/nix/checks.nix args';

    ## Developer Shells ##
    # Default Shell
    devShell = import ./shells args';

    # Tailored Shells
    devShells = map.modules ./shells (name: pkgs.mkShell (import name pkgs));

    ## Package Configuration ##
    legacyPackages = self.channels.${system}.stable;
    channels = {
      stable = pkgs;
      unstable = pkgs';
    };

    # Custom Packages
    defaultApp = self.apps.${system}.nixos;
    defaultPackage = self.packages.${system}.dotfiles;
    apps = map.modules ./scripts (name: pkgs.callPackage name args');
    packages = self.apps.${system} // pack.nixosConfigurations
      // pack.installMedia.iso
      // map.modules ./packages (name: pkgs.callPackage name args');
  }) // {
    # Overrides
    overlays = map.modules ./packages/overlays import;

    ## Program Configuration and `dotfiles` ##
    files = import ./files;

    ## Custom Library Functions ##
    lib = import ./lib args // { lib = nixpkgs.lib; };

    ## Custom Configuration Modules ##
    nixosModule = import ./modules args;
    nixosModules = map.merge map.modules ./modules ./secrets import
      // home.nixosModules // sops.nixosModules // utils.nixosModules;

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
