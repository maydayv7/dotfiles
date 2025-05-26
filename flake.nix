###############################################
#           ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖          #
#           ▜███▙       ▜███▙  ▟███▛          #
#            ▜███▙       ▜███▙▟███▛           #
#             ▜███▙       ▜██████▛            #
#      ▟█████████████████▙ ▜████▛     ▟▙      #
#     ▟███████████████████▙ ▜███▙    ▟██▙     #
#            ▄▄▄▄▖           ▜███▙  ▟███▛     #
#           ▟███▛             ▜██▛ ▟███▛      #
#          ▟███▛               ▜▛ ▟███▛       #
# ▟███████████▛                  ▟██████████▙ #
# ▜██████████▛                  ▟███████████▛ #
#       ▟███▛ ▟▙               ▟███▛          #
#      ▟███▛ ▟██▙             ▟███▛           #
#     ▟███▛  ▜███▙           ▝▀▀▀▀            #
#     ▜██▛    ▜███▙ ▜██████████████████▛      #
#      ▜▛     ▟████▙ ▜████████████████▛       #
#            ▟██████▙       ▜███▙             #
#           ▟███▛▜███▙       ▜███▙            #
#          ▟███▛  ▜███▙       ▜███▙           #
#          ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘           #
#   ---------------------------------------   #
#     Author  -> V 7 <maydayv7@gmail.com>     #
#     License -> MIT                          #
#     URL     -> github:maydayv7/dotfiles     #
#   ---------------------------------------   #
#           Welcome to Ground Zero!           #
#       The very heart of my 'dotfiles'       #
###############################################
{
  description = ''
    My Self-Contained, Purely Reproducible, Hermetic, Declarative, Automated, Extensible
    Multi-PC NixOS Configuration and 'dotfiles'
  '';

  ## Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Packages Repository
    nixpkgs.follows = "stable";
    stable.url = "github:NixOS/nixpkgs?ref=nixos-25.05";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Proprietary Software
    proprietary = {
      url = "github:maydayv7/proprietary";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packaged Games
    gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "framework";
    };

    ## Configuration Modules ##
    ## Language Addendum
    # Supported Architectures
    systems = {
      url = "github:maydayv7/dotfiles?ref=systems";
      flake = false;
    };

    # Flakes Framework
    framework = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Flake Utility Functions
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # Source Filter Functions
    filters.url = "github:numtide/nix-filter";

    # Syntax Formatter
    formatter = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Feature Modules
    # User Home Manager
    home = {
      url = "github:nix-community/home-manager?ref=release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Support
    hardware.url = "github:NixOS/nixos-hardware";

    # Secure Boot
    boot = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "framework";
      };
    };

    # Authentication Credentials Manager
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };

    # Filesystem State Handler
    impermanence.url = "github:nix-community/impermanence";

    # Nix Index Database
    index = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Flatpak Wrapper
    flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    # VS Code Extensions
    vscode = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };

    # Discord Module
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs = {
        nixpkgs.follows = "unstable";
        systems.follows = "systems";
        treefmt-nix.follows = "formatter";
      };
    };

    # Windows Apps Wrapper
    windows = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "unstable";
    };

    ## Theming
    # Base16 Theming Module
    stylix = {
      url = "github:nix-community/stylix?ref=release-25.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "framework";
        home-manager.follows = "home";
      };
    };

    # Spicetify Module
    spotify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Catppuccin Theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Hyprland
    # Core
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Plugins
    hyprplugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    hyprcursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs = {
        hyprland.follows = "hyprland";
        systems.follows = "systems";
      };
    };

    hyprdark = {
      url = "github:micha4w/Hypr-DarkWindow";
      inputs = {
        hyprland.follows = "hyprland";
        nix-filter.follows = "filters";
      };
    };

    # Launcher
    hyprshell = {
      url = "github:H3rmt/hyprshell-test";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ## Configuration ##
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;
      map = import ./lib/map.nix lib;
    in
    inputs.framework.lib.mkFlake { inherit inputs; } {
      inherit (self) systems;
      debug = false;

      imports = map.flake ./.;
      _module.args = {
        util = self.lib;
      };

      flake = {
        # Supported Architectures
        systems = import inputs.systems;

        ## Custom Library Functions ##
        lib = lib.recursiveUpdate (map.modules ./lib (file: import file lib)) {
          nixpkgs = lib;
          build.device = import ./modules/configuration.nix inputs;
        };

        ## Configuration Template ##
        templates.default = with inputs.filters.lib; {
          description = "My NixOS Configuration";
          path = filter {
            root = ./.;
            exclude = [
              ./checks
              ./site
              (matchExt "md")
              (matchExt "secret")
            ];
          };
        };
      };
    };

  ## Nix Configuration ##
  nixConfig = {
    commit-lockfile-summary = "chore(flake): Update `inputs`";

    # Binary Caches
    trusted-substituters = [
      "https://maydayv7-dotfiles.cachix.org"
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://catppuccin.cachix.org"
    ];

    # Public Keys
    trusted-public-keys = [
      "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };
}
