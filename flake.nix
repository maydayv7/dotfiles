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
#     Version -> vNEXT                        #
#   ---------------------------------------   #
#           Welcome to Ground Zero!           #
#       The Very Heart of my 'dotfiles'       #
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
    nixpkgs.url = "github:NixOS/nixpkgs?ref=release-23.11";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Chaotic Packages Repository
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };

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
      url = "path:devices/systems.nix";
      flake = false;
    };

    # Flakes Framework
    framework = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Flake Utility Functions
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.inputs.systems.follows = "systems";
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
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Support
    hardware.url = "github:nixos/nixos-hardware";

    # Secure Boot
    boot = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "framework";
        flake-utils.follows = "utils/flake-utils";
      };
    };

    # Authentication Credentials Manager
    sops = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "unstable";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    # File System Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    # System Image Generators
    generators = {
      url = "github:nix-community/nixos-generators";
      inputs = {
        nixlib.follows = "nixpkgs";
        nixpkgs.follows = "unstable";
      };
    };

    # Nix Index Database
    index = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Base16 Theming
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.systems.follows = "systems";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };

    # Declarative Flatpak Wrapper
    flatpak.url = "github:gmodena/nix-flatpak";

    # VS Code Extensions
    vscode = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils/flake-utils";
      };
    };

    vscode-catppuccin = {
      url = "github:catppuccin/vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Windows VM Creator
    wfvm = {
      url = "git+https://git.m-labs.hk/M-Labs/wfvm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Windows Apps Wrapper
    windows = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  ## Configuration ##
  outputs = {self, ...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    map = import ./lib/map.nix lib;
  in
    inputs.framework.lib.mkFlake {inherit inputs;} {
      inherit (self) systems;
      debug = false;

      _module.args = {util = self.lib;};
      imports = map.flake ./.;

      flake = {
        # Supported Architectures
        systems = import inputs.systems;

        ## Custom Library Functions ##
        lib =
          lib.recursiveUpdate (map.modules ./lib (file: import file lib))
          {
            nixpkgs = lib;
            build.device = import ./modules/configuration.nix {inherit lib inputs;};
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
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://nyx.chaotic.cx/"
      "https://maydayv7-dotfiles.cachix.org"
    ];

    # Public Keys
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
    ];
  };
}
