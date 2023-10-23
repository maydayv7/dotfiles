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
#     Version -> v13                          #
#   ---------------------------------------   #
#           Welcome to Ground Zero!           #
#       The Very Heart of my 'dotfiles'       #
###############################################
{
  description = ''
    My Self-Contained, Purely Reproducible, Hermetic, Declarative, Automated, Extensible
    Multi-PC NixOS Configuration and 'dotfiles'
  '';

  ## Nix Configuration ##
  nixConfig = {
    commit-lockfile-summary = "chore(flake.lock): Update `inputs`";

    # Binary Caches
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://maydayv7-dotfiles.cachix.org"
    ];

    # Public Keys
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "maydayv7-dotfiles.cachix.org-1:dpECO0Z2ZMttY6JgWHuAR5M7cqeyfFjUsvHdnMz+j6U="
    ];
  };

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Packages Repository
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Proprietary Software
    proprietary.url = "github:maydayv7/proprietary";

    # Packaged Games
    gaming.url = "github:fufexan/nix-gaming";

    ## Configuration Modules ##
    ## Language Addendum
    # Supported Architectures
    systems = {
      url = "path:./systems.nix";
      flake = false;
    };

    # Flake Utility Functions
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.inputs.systems.follows = "systems";
    };

    # Source Filter Functions
    filter.url = "github:numtide/nix-filter";
    ignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-Commit Hooks
    hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils/flake-utils";
      inputs.gitignore.follows = "ignore";
    };

    ## Feature Modules
    # User Home Manager
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Support
    hardware.url = "github:nixos/nixos-hardware";

    # Authentication Credentials Manager
    sops.url = "github:Mic92/sops-nix";

    # File System Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    # System Image Generators
    generators.url = "github:nix-community/nixos-generators";

    # Nix Index Database
    index = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Base16 Theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home";
    };

    # Windows VM Creator
    windows = {
      url = "git+https://git.m-labs.hk/M-Labs/wfvm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wine Apps Wrapper
    wine = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ## System Configuration ##
  outputs = args: import ./configuration.nix args;
}
