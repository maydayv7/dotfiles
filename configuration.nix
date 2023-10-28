{self, ...} @ inputs: let
  ## Variable Declaration ##
  # Supported Architectures
  systems = import inputs.systems;

  # System Libraries
  inherit (self) files;
  inherit (lib.util) build map pack;
  lib = with inputs;
    nixpkgs.lib.extend (final: prev:
      {
        filters = ignore.lib // {inherit (filter.lib) filter matchExt;};
        hooks = hooks.lib;
        image = generators.nixosGenerate;
        wine = wine.lib;
      }
      // {
        util = import ./lib {
          inherit self systems;
          lib = final;
        };
      }
      // home.lib
      // utils.lib);
in
  lib.eachSystem systems (system: let
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
    legacyPackages = self.channels."${system}".nixpkgs;

    # Package Channels
    channels = with inputs; {
      nixpkgs = (build.channel nixpkgs [nur.overlay])."${system}";
      wine = wine.packages."${system}";
      gaming = gaming.packages."${system}";
      generators = generators.packages."${system}".default;
    };

    # Custom Packages
    apps =
      map.modules ./scripts (name: lib.mkApp {drv = call name;})
      // {default = self.apps."${system}".nixos;};
    packages =
      map.modules ./packages call
      // map.modules ./scripts call
      // {default = self.packages."${system}".dotfiles;}
      // inputs.proprietary.packages."${system}";
  })
  // {
    # Overrides
    overlays = map.modules ./packages/overlays import;

    ## Custom Library Functions ##
    lib =
      lib.util
      // {
        inherit systems;
        nixpkgs = inputs.nixpkgs.lib;
      };

    ## Program Configuration and 'dotfiles' ##
    files = import ./files lib inputs;

    ## Custom Configuration Modules ##
    nixosModules =
      map.modules ./modules import
      // {default = import ./modules {inherit lib inputs files;};};

    ## Configuration Templates ##
    templates = import ./.templates lib;

    ## Device Configuration ##
    nixosConfigurations = map.modules ./devices (name: build.device (import name));

    ## Virtual Machines ##
    vmConfigurations =
      map.modules ./devices/vm
      (name: import name inputs.windows.lib self.legacyPackages."${builtins.head systems}");

    ## Install Media Configuration ##
    installMedia = let
      config = {
        timezone = "Asia/Kolkata";
        locale = "IN";
        kernel = "zfs";
      };
    in rec {
      default = xfce;
      gnome = build.iso (config // {gui.desktop = "gnome";});
      xfce = build.iso (config // {gui.desktop = "xfce";});
    };
  }
