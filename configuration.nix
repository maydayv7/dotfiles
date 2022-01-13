{ self, ... } @ inputs:
with inputs;
let
  ## Variable Declaration ##
  # Supported Architectures
  systems = [ "x86_64-linux" ];

  # NixOS Version
  version = builtins.readFile ./.version;

  # System Libraries
  files = self.files;
  inherit (lib) build map pack;
  lib = nixpkgs.lib // home.lib // utils.lib // { hooks = hooks.lib; } // self.lib;
in
utils.lib.eachSystem systems
(system:
  let
    # Package Channels
    pkgs = (build.channel nixpkgs [ nur.overlay ] ./packages/patches)."${system}";
    pkgs' = (build.channel unstable [ nur.overlay ] [ ])."${system}";
  in
  {
    ## Configuration Checks ##
    checks = import ./modules/nix/checks.nix { inherit system lib pkgs; };

    ## Developer Shells ##
    # Default Shell
    devShell = import ./shells { inherit pkgs; };

    # Tailored Shells
    devShells = map.modules ./shells (name: import name { inherit pkgs; });

    ## Package Configuration ##
    channels = { stable = pkgs; unstable = pkgs'; };
    legacyPackages = self.channels."${system}".stable;

    # Custom Packages
    defaultApp = self.apps."${system}".nixos;
    defaultPackage = self.packages."${system}".dotfiles;
    apps = map.modules ./scripts (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
    packages = self.apps."${system}" // pack.nixosConfigurations // pack.installMedia.iso // map.modules ./packages (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
  }
)
//
{
  # Overrides
  overlay = final: prev: { home-manager = prev.callPackage "${inputs.home}/home-manager" { }; };
  overlays = map.modules ./packages/overlays import;

  ## Program Configuration and `dotfiles` ##
  files = import ./files;

  ## Custom Library Functions ##
  lib = import ./lib { inherit systems inputs; lib = nixpkgs.lib; };

  ## Custom Configuration Modules ##
  nixosModule = import ./modules { inherit version lib inputs files; };
  nixosModules = map.merge map.modules ./modules ./secrets import;

  ## Configuration Templates ##
  defaultTemplate = self.templates.minimal;
  templates =
  {
    extensive = { path = ./.; description = "My Complete, Extensive NixOS Configuration"; };
    minimal = { path = ./.templates/minimal; description = "Simple, Minimal NixOS Configuration"; };
  };

  ## Install Media Configuration ##
  installMedia =
  {
    # GNOME Desktop
    gnome = build.iso
    {
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";

      kernel = "linux_5_15";
      desktop = "gnome-minimal";
    };
  };

  ## Device Configuration ##
  nixosConfigurations = map.modules ./devices (name: build.device (import name hardware.nixosModules));
}
