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
#     Author  -> V 7 <mail@maydayv7.cc>       #
#     License -> MIT                          #
#     URL     -> github:maydayv7/dotfiles     #
#   ---------------------------------------   #
###############################################
{
  description = ''
    My declarative, hermetic, reproducible, automated, extensible, multi-PC
    NixOS Configuration and 'dotfiles'
  '';

  ## Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Packages Repository
    nixpkgs.follows = "stable";
    stable.url = "github:NixOS/nixpkgs?ref=nixos-26.05";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Packaged Games
    gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Proprietary Software
    proprietary = {
      url = "github:maydayv7/proprietary";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal Stagit Fork
    stagit = {
      url = "github:maydayv7/stagit";
      inputs = {
        nixpkgs.follows = "stable";
        utils.follows = "utils";
      };
    };

    # VS Code Extensions
    vscode = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Configuration Modules ##
    ## Language Addendum
    # Supported Architectures
    systems = {
      url = "github:maydayv7/dotfiles?ref=systems";
      flake = false;
    };

    # Flakes Framework
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Module Tree Import Functions
    import-tree.url = "github:denful/import-tree";

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
    # Hardware Support
    hardware.url = "github:NixOS/nixos-hardware";

    # User Home Manager
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secure Boot
    boot = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Authentication Credentials Manager
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };

    # Filesystem State Handler
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Nix Index Database
    index = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Flatpak Wrapper
    flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    # Discord Module
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs = {
        nixpkgs.follows = "unstable";
        flake-parts.follows = "flake-parts";
      };
    };

    # Minecraft Server
    minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
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
      url = "github:nix-community/stylix?ref=release-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };

    # Spicetify Module
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Catppuccin Theme
    catppuccin = {
      url = "github:catppuccin/nix?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Hyprland
    # Core
    hyprland = {
      url = "github:hyprwm/hyprnix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Plugins
    hyprsplit = {
      url = "github:zjeffer/split-monitor-workspaces/v0.55.4";
      inputs = {
        hyprland.follows = "hyprland";
        nix-filter.follows = "filters";
      };
    };

    hyprcursors = {
      url = "github:VirtCode/hypr-dynamic-cursors/da447486c84e0be81f2cdd208af1ef92469f0a88";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprland.follows = "hyprland";
      };
    };

    # Launcher
    hyprshell = {
      url = "github:H3rmt/hyprshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  ## Configuration ##
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    # Auto-import all flake-parts modules from ./modules
    {
      imports = [
        (inputs.import-tree ./modules)
        ./files/_module.nix
        ./lib/_module.nix
        ./packages/_module.nix
        ./secrets/_module.nix
        ./site/_module.nix
      ];
    };

  ## Nix Configuration ##
  nixConfig = {
    commit-lockfile-summary = "chore(flake): Update `inputs`";

    # Binary Caches
    trusted-substituters = [
      "https://maydayv7-dotfiles.cachix.org"
      "https://cache.nixos.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.flox.dev"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://catppuccin.cachix.org"
    ];

    # Public Keys
    trusted-public-keys = [
      "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };
}
